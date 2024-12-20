include("dwf.jl")
using CairoMakie
using DataFrames
using CSV
phdwf = Ref{c"HDWF"}()
cdev = Ref{Cint}()

FDwfEnum(0, cdev)
FDwfDeviceOpen(-1, phdwf)
FDwfDeviceAutoConfigureSet(phdwf[], 0)

f_min = 5.0
f_max = 800.0
nf = 50
df = (f_max - f_min)/nf
buff = 8000
amp = 1.0

data = Dict()
ff1 = f_min
rg1 = Vector{Cdouble}(undef, buff)
rg2 = Vector{Cdouble}(undef, buff)
while true
    if ff1 > f_max
        break
    end
    sf1 = ff1*100
    # FDwfAnalogOutNodeEnableSet(phdwf[], 0, 0, 1)
    # FDwfAnalogOutNodeFunctionSet(phdwf[], 0, 0, 1)
    # FDwfAnalogOutNodeFrequencySet(phdwf[], 0, 0, ff1)
    # FDwfAnalogOutNodeAmplitudeSet(phdwf[], 0, 0, amp)
    ff2 = f_min
    while true
        if ff2 > f_max
            break
        end
        sf2 = ff2*100
        sf = max(sf1, sf2)
        FDwfAnalogOutNodeEnableSet(phdwf[], 0, 0, 1)
        FDwfAnalogOutNodeFunctionSet(phdwf[], 0, 0, 1)
        FDwfAnalogOutNodeFrequencySet(phdwf[], 0, 0, ff1)
        FDwfAnalogOutNodeAmplitudeSet(phdwf[], 0, 0, amp)
        FDwfAnalogOutNodeEnableSet(phdwf[], 1, 0, 1)
        FDwfAnalogOutNodeFunctionSet(phdwf[], 1, 0, 1)
        FDwfAnalogOutNodeFrequencySet(phdwf[], 1, 0, ff2)
        FDwfAnalogOutNodeAmplitudeSet(phdwf[], 1, 0, amp)
        FDwfAnalogOutConfigure(phdwf[], 0, 1)
        FDwfAnalogOutConfigure(phdwf[], 1, 1)
        print("analog out on. f1:$ff1 , f2:$ff2 \n")

        FDwfAnalogInFrequencySet(phdwf[], sf)
        FDwfAnalogInChannelRangeSet(phdwf[], -1, 4.0)
        FDwfAnalogInBufferSizeSet(phdwf[], 100000)
        FDwfAnalogInConfigure(phdwf[], 1, 0)

        sleep(0.001)

        FDwfAnalogInConfigure(phdwf[], 1, 1)

        sts = Ref{c"DwfState"}()
        while true
            FDwfAnalogInStatus(phdwf[], 1, sts)
            if sts[] == c"DwfState"(2)
                break
            end
        end
        print("done\n")

        FDwfAnalogInStatusData(phdwf[], 0, rg1, length(rg1))
        FDwfAnalogInStatusData(phdwf[], 1, rg2, length(rg2))
        tt = [(i-1)/sf for i in 1:buff]
        tempd = DataFrame(:V1 => rg1, :V2 => rg2, :t=>tt)
        push!(data, (ff1, ff2) => tempd)
        FDwfAnalogOutReset(phdwf[], 0)
        FDwfAnalogInReset(phdwf[])

        ff2 += df
    end
    ff1 += df
end
FDwfCloseAll()
closedl()
dirn = "data2" 
mkdir(dirn)
for k in keys(data)
    fn = join([k, ".csv"])
    fp = joinpath(dirn, fn)
    CSV.write(fp, data[k])
end
