cd(@__DIR__)
using Libdl
const dwf = Libdl.dlopen("C:\\Windows\\System32\\dwf.dll")

using CBinding
c``
c"""
#include "C:\\Program Files (x86)\\Digilent\\WaveFormsSDK\\inc\\dwf.h"
"""

### device
function FDwfEnum(enumfilter::Int, pnDevice::Ref{Cint})
    @ccall "dwf".FDwfEnum(c"ENUMFILTER"(enumfilter)::c"ENUMFILTER", pnDevice::Ref{Cint})::Cvoid
end
function FDwfDeviceOpen(idxDevice::Int, HDWF::Ref{c"HDWF"})
    @ccall "dwf".FDwfDeviceOpen(Cint(idxDevice)::Cint, HDWF::Ref{c"HDWF"})::Cvoid
end
function FDwfDeviceAutoConfigureSet(hdwf::c"HDWF", fAC::Int)
    @ccall "dwf".FDwfDeviceAutoConfigureSet(hdwf::c"HDWF", Cint(fAC)::Cint)::Cvoid
end
function FDwfDeviceTriggerInfo(hdwf::c"HDWF", pfs::Ref{Cint})
    @ccall "dwf".FDwfDeviceTriggerInfo(hdwf::c"HDWF", pfs::Ref{Cint})::Cvoid
end
function FDwfCloseAll()
    @ccall "dwf".FDwfDeviceCloseAll()::Cvoid
end


### Analog In
function FDwfAnalogInReset(hdwf::c"HDWF")
    @ccall "dwf".FDwfAnalogInReset(hdwf::c"HDWF")::Cvoid
end
function FDwfAnalogInConfigure(hdwf::c"HDWF", fRec::Int, fstart::Int)
    @ccall "dwf".FDwfAnalogInConfigure(hdwf::c"HDWF", Cint(fRec)::Cint, Cint(fstart)::Cint)::Cvoid
end
function FDwfAnalogInStatus(hdwf::c"HDWF", fRD::Int, psts::Ref{c"DwfState"})
    @ccall "dwf".FDwfAnalogInStatus(hdwf::c"HDWF", Cint(fRD)::Cint, psts::Ref{c"DwfState"})::Cvoid
end

function FDwfAnalogInStatusData(HDWF::c"HDWF", idxChannel::Int, rgdVoltdata::Vector{Cdouble}, cdData::Int)
    @ccall "dwf".FDwfAnalogInStatusData(HDWF::c"HDWF", Cint(idxChannel)::Cint, rgdVoltdata::Ptr{Cdouble}, Cint(cdData)::Cint)::Cvoid
end
function FDwfAnalogInFrequencySet(hdwf::c"HDWF", hzFrequency::Float64)
    @ccall "dwf".FDwfAnalogInFrequencySet(hdwf::c"HDWF", Cdouble(hzFrequency)::Cdouble)::Cvoid
end
function FDwfAnalogInBufferSizeSet(hdwf::c"HDWF", nsize::Int)
    @ccall "dwf".FDwfAnalogInBufferSizeSet(hdwf::c"HDWF", Cint(nsize)::Cint)::Cvoid
end
function FDwfAnalogInChannelRangeSet(hdwf::c"HDWF", idxChannel::Int, voltsRange::Float64)
    @ccall "dwf".FDwfAnalogInChannelRangeSet(hdwf::c"HDWF", Cint(idxChannel)::Cint, Cdouble(voltsRange)::Cdouble)::Cvoid
end


### Analog Out
function FDwfAnalogOutReset(hdwf::c"HDWF", idxChannel::Int)
    @ccall "dwf".FDwfAnalogOutReset(hdwf::c"HDWF", Cint(idxChannel)::Int)::Cvoid
end
function FDwfAnalogOutConfigure(hdwf::c"HDWF", idxChannel::Int, fStart::Int)
    @ccall "dwf".FDwfAnalogOutConfigure(hdwf::c"HDWF", Cint(idxChannel)::Cint, Cint(fStart)::Cint)::Cvoid
end
function FDwfAnalogOutNodeEnableSet(hdwf::c"HDWF", idxC::Int, node::Int, fMode::Int)
    @ccall "dwf".FDwfAnalogOutNodeEnableSet(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", Cint(fMode)::Cint)::Cvoid
end
function FDwfAnalogOutNodeFunctionSet(hdwf::c"HDWF", idxC::Int, node::Int, func::Int)
    @ccall "dwf".FDwfAnalogOutNodeFunctionSet(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", c"FUNC"(func)::c"FUNC")::Cvoid
end
function FDwfAnalogOutNodeAmplitudeSet(hdwf::c"HDWF", idxC::Int, node::Int, vAmp::Float64)
    @ccall "dwf".FDwfAnalogOutNodeAmplitudeSet(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", Cdouble(vAmp)::Cdouble)::Cvoid
end
function FDwfAnalogOutNodeAmplitudeGet(hdwf::c"HDWF", idxC::Int, node::Int, pvAmp::Ref{Cdouble})
    @ccall "dwf".FDwfAnalogOutNodeAmplitudeGet(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", pvAmp::Ref{Cdouble})::Cvoid
end
function FDwfAnalogOutNodePhaseInfo(hdwf::c"HDWF", idxC::Int, node::Int, pdegmin::Ref{Cdouble}, pdegmax::Ref{Cdouble})
    @ccall "dwf".FDwfAnalogOutNodePhaseInfo(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", pdegmin::Ref{Cdouble}, pdegmax::Ref{Cdouble})::Cvoid
end
function FDwfAnalogOutNodePhaseSet(hdwf::c"HDWF", idxC::Int, node::Int, dph::Float64)
    @ccall "dwf".FDwfAnalogOutNodePhaseSet(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", Cdouble(dph)::Cdouble)::Cvoid
end
function FDwfAnalogOutNodePhaseGet(hdwf::c"HDWF", idxC::Int, node::Int, pdph::Ref{Cdouble})
    @ccall "dwf".FDwfAnalogOutNodePhaseSet(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", pdph::Ref{Cdouble})::Cvoid
end
function FDwfAnalogOutNodeFrequencySet(hdwf::c"HDWF", idxC::Int, node::Int, hzF::Float64)
    @ccall "dwf".FDwfAnalogOutNodeFrequencySet(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", Cdouble(hzF)::Cdouble)::Cvoid
end
function FDwfAnalogOutNodeFrequencyGet(hdwf::c"HDWF", idxC::Int, node::Int, phzF::Ref{Cdouble})
    @ccall "dwf".FDwfAnalogOutNodeFrequencySet(hdwf::c"HDWF", Cint(idxC)::Cint, c"AnalogOutNode"(node)::c"AnalogOutNode", phzf::Ref{Cdouble})::Cvoid
end

function closedl()
    dlclose(dwf)
end