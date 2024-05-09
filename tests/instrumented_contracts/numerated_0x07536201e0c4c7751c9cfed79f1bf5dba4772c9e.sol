1 pragma solidity ^0.4.2;
2 contract Sign {
3 
4 	address public AddAuthority;	
5 	mapping (uint32 => bytes32) Cert;	
6 	
7 	// =============================================
8 	
9 	function Sign() {
10 		AddAuthority = msg.sender;
11 		Cert [0] = 0x7a1d671e46f713a33286d4b4215796c8d396fd0e7cedf0b4e01d071df0f1412a;
12 		Cert [1] = 0x5705f82396973f8f3861f1c29d7962e3234ff732723e39689ca7e7c030580000;
13 	}
14 
15 	function () {throw;} // reverse
16 	
17 	function destroy() {if (msg.sender == AddAuthority) {selfdestruct(AddAuthority);}}
18 	
19 	function SetCert (uint32 _IndiceIndex, bytes32 _Cert) {
20 		if (msg.sender == AddAuthority) {
21 			Cert [_IndiceIndex] = _Cert;
22 		}
23 	}				
24 	
25 	function GetCert (uint32 _IndiceIndex) returns (bytes32 _Valeur)  {
26 		_Valeur = Cert [_IndiceIndex];
27 		return _Valeur;
28 	}		
29 }