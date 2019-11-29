;EasyCodeName=GetModuleHandleW,1
.386
.Model flat, StdCall
Option CaseMap: none

Include	trap.inc

.Const

.Data?

.Data

.Code

GetModuleHandleWTrap Proc Uses Ebx Ecx Edx Esi Edi, lpModuleName: Ptr WCHAR
	; Mov Esi, 0x********
	Mov_Esi_Information
	; Pointer to ImageInformation
	Assume Esi: Ptr ImageInformation

	.If lpModuleName == 0
		Push 0
		Call [Esi].traps[SizeOf ImageTrap * TRAP_ID_GET_MODULE_HANDLE_W].procedure
	.Else
		Lea Ebx, [Esi].ModuleNameW
		Push Ebx
		Push lpModuleName
		Call [Esi].apis.lstrcmpiW
        
        Cmp Eax, 0
        Je __COPY
		
		Lea Ebx, [Esi].ModuleBaseNameW
		Push Ebx
		Push lpModuleName
		Call [Esi].apis.lstrcmpiW   
        
        Cmp Eax, 0
        Jne __CALL
        
    __COPY:
		Mov Eax, [Esi].imagebase
		Jmp @F

    __CALL:    
        Push lpModuleName
        Call [Esi].traps[SizeOf ImageTrap * TRAP_ID_GET_MODULE_HANDLE_W].procedure
	@@:
	.EndIf

	Return Eax
GetModuleHandleWTrap EndP

End
