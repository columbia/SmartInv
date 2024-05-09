1 pragma solidity ^0.4.2;
2 contract Sign {
3 
4 	address public AddAuthority;	
5 	mapping (uint32 => bytes32) Cert;	
6 	
7 	event EventNotarise (address indexed Signer, bytes Donnees_Signature, bytes Donnees_Reste);
8 
9 	// =============================================
10 	
11 	function Sign() {AddAuthority = msg.sender;}
12 
13 	function () {throw;} // reverse
14 	
15 	function destroy() {if (msg.sender == AddAuthority) {selfdestruct(AddAuthority);}}
16 	
17 	function SetCert (uint32 _IndiceIndex, bytes32 _Cert) {
18 		Cert [_IndiceIndex] = _Cert;
19 	}				
20 	
21 	function GetCert (uint32 _IndiceIndex) returns (bytes32 _Valeur)  {
22 		_Valeur = Cert [_IndiceIndex];
23 	}		
24 	
25 
26  	// ====================================
27 
28 	function VerifSignature (bytes _Signature, bytes _Reste) returns (bool) {
29 		// Vérification de la signature _Signature
30 		// _Reste : hash / Signer 
31 		// Décompose _Signature
32 		bytes32 r;
33 		bytes32 s;
34 		uint8 v;
35 		bytes32 hash;
36 		address Signer;
37         assembly {
38             r := mload(add(_Signature, 32))
39             s := mload(add(_Signature, 64))
40             // v := byte(0, mload(add(_Signature, 96)))
41             v := and(mload(add(_Signature, 65)), 255)
42             hash := mload(add(_Reste, 32))
43             Signer := mload(add(_Reste, 52))
44         }		
45 		return Signer == ecrecover(hash, v, r, s);
46 	}
47 	
48 	function VerifCert (uint32 _IndiceIndex, bool _log, bytes _Signature, bytes _Reste) returns (uint status) {					
49 		status = 0;
50 		// Test de la validité de Cert
51 		if (Cert [_IndiceIndex] != 0) {
52 			status = 1;
53 			// Test de la signature
54 			if (VerifSignature (_Signature, _Reste)) {
55 				// _Reste : hash / Signer / 
56 				address Signer;
57 				assembly {Signer := mload(add(_Reste, 52))}		
58 			} else {
59 				// Cert valide mais signature invalide 
60 				status = 2;							
61 			}		
62 			// Log si demandé
63 			if (_log) {
64 				EventNotarise (Signer, _Signature, _Reste);
65 				status = 3;							
66 			}
67 		}
68 		return (status);
69 	}
70 	
71 }