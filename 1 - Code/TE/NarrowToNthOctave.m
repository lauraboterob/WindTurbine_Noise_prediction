%Program to convert narrowband data to 1/n octaveband data. Just send it an
%array of band center frequencies, the dB values to sort, and the nth 
%octave band you want. This can be used with any dB values (e.g. Sound
%pressure level (SPL), sound power (Lw), sound intensity (Li), etc..
%
%Important Note 1: The given center frequencies must be a constant df apart
%
%Important Note 2: If your data was windowed during the FFT process and you
%used the amplitude correction factor (ACF), then you need to adjust your
%data to the energy correction factor when converting to octave spectra. See
%the first couple lines of the function to adjust this.
%More reading here: http://blog.prosig.com/2009/09/01/amplitude-and-energy-correction-a-brief-summary/
%
%-Examples: 
%[sortedData,Fc,Flow,Fhigh] = NarrowToNthOctave([490,510,500],[60,60,60],1)
%[sortedData,Fc] = NarrowToNthOctave([490,510,500],[60,60,60],3)
%[sortedData,Fc] = NarrowToNthOctave(freqArray,dBArray,3)
%
%-V4 TMB 12/1/2015
function [sortedData,Fc,Flow,Fhigh] = NarrowToNthOctave(arrayOfNBCenterFreqs,arrayOfdBToConvert,n)
df=arrayOfNBCenterFreqs(2)-arrayOfNBCenterFreqs(1);
%Determine Initial Center frequency (Fc)
previous=1000*2^(1/n);
lowFc=1000; %Start at 1000 Hz and find lowest Fc
while (previous-lowFc) > df
    previous=lowFc;
    lowFc=lowFc/2^(1/n);
end
%Compute center frequencies
ii=1;
Fc(ii)=lowFc;
while Fc(ii) <= max(arrayOfNBCenterFreqs) 
    ii=ii+1;
    Fc(ii)=2^(1/n)*Fc(ii-1);
end
%Compute high, low frequencies, and bandwidth (BW) from center frequencies
    Flow=Fc/sqrt(2^(1/n));
    Fhigh=Fc*sqrt(2^(1/n));
    BW=Fhigh-Flow;
%Sort data in frequency bins
sortedData=zeros(1,length(Fc)); zeroFreqValue=0;
for jj=1:length(arrayOfdBToConvert) %Do for each value given
    for kk=1:length(Fc) %Check each Fc bin to see where value should be placed
        if arrayOfNBCenterFreqs(jj)>=Flow(kk) && arrayOfNBCenterFreqs(jj)<Fhigh(kk) %Find place. In the rare case a given center freq = flow(ii)/fhigh(ii+1) then sum the value in flow
            if sortedData(kk)==0 %if no values has been added to the band then set initial value
                sortedData(kk)=arrayOfdBToConvert(jj);
                N(kk)=1;
            else %else sum in the value
                sortedData(kk)=10*log10(sum(10.^([sortedData(kk) arrayOfdBToConvert(jj)]./10))); %dB add value to that bin
                N(kk)=N(kk)+1;
            end
        else %else check to see if the value belongs in the 0 Hz band
            if (kk==1) && arrayOfNBCenterFreqs(jj)<Flow(kk)
                if zeroFreqValue==0
                    zeroFreqValue=arrayOfdBToConvert(jj);
                else
                    zeroFreqValue=10*log10(sum(10.^([zeroFreqValue arrayOfdBToConvert(jj)]./10))); %dB add value to that bin
                end
            end
        end
    end
end
%Apply bin correction factor for when center frequencies are not integer
%multiples of the bandwidth (BW)
for ll=1:length(N) %Look through each bin that had values added to it
    if (N(ll)~=0) && (floor(BW(ll)/df)<=N(ll)) %If values were added and there are enough values added to make applying the correction appropriate then apply correction
        sortedData(ll)=sortedData(ll)+10*log10(BW(ll)/(df*N(ll)));
    end
end
%If DC value was given, add to sorted array
if zeroFreqValue~=0
    sortedData=[zeroFreqValue sortedData];
    Fc=[0 Fc];
    Flow=[0 Flow];
    Fhigh=[0 Fhigh];
end
%Remove unused bins at beginning if only higher freqs were given
removeThisMany=0;
for ll=1:length(sortedData)
    if sortedData(ll)==0;
        removeThisMany=1+removeThisMany;
    else
        break
    end
end
sortedData=sortedData(removeThisMany+1:end);
Fc=Fc(removeThisMany+1:end);
Flow=Flow(removeThisMany+1:end);
Fhigh=Fhigh(removeThisMany+1:end);
%Remove bin at end if unused
if sortedData(end)==0
    sortedData=sortedData(1:end-1);
    Fc=Fc(1:end-1);
    Flow=Flow(1:end-1);
    Fhigh=Fhigh(1:end-1);
end
end