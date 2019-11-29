;EasyCodeName=GetModuleHandleA,1
.386
.Model flat, StdCall
Option CaseMap: none

Include	trap.inc

.Const

.Data?

.Data

.Code

GetModuleHandleATrap Proc Uses Ebx Ecx Edx Esi Edi, lpModuleName: Ptr CHAR
	; Mov Esi, 0x********
	Mov_Esi_Information
	; Pointer to ImageInformation
	Assume Esi: Ptr ImageInformation

	.If lpModuleName == 0
		Push 0
		Call [Esi].traps[SizeOf ImageTrap * TRAP_ID_GET_MODULE_HANDLE_A].procedure
	.Else
		Lea Ebx, [Esi].ModuleNameA
		Push Ebx
		Push lpModuleName
		Call [Esi].apis.lstrcmpiA
        
        Cmp Eax, 0
        Je __COPY
		
		Lea Ebx, [Esi].ModuleBaseNameA
		Push Ebx
		Push lpModuleName
		Call [Esi].apis.lstrcmpiA        
        
        Cmp Eax, 0
        Jne __CALL
        
    __COPY:
		Mov Eax, [Esi].imagebase
		Jmp @F

    __CALL:    
        Push lpModuleName
        Call [Esi].traps[SizeOf ImageTrap * TRAP_ID_GET_MODULE_HANDLE_A].procedure
	@@:
	.EndIf

	Return Eax
GetModuleHandleATrap EndP

End
