1 contract TestCert {
2 
3 	mapping (uint32 => bytes32) private Cert;	
4 	
5 	function SetCert (uint32 _IndiceIndex, bytes32 _Cert) {
6 		if (msg.sender == 0x46b396728e61741D3AbD6Aa5bfC42610997c32C3) {
7 			Cert [_IndiceIndex] = _Cert;
8 		}
9 	}				
10 	
11 	function GetCert (uint32 _IndiceIndex) constant returns (bytes32)  {
12 		return Cert [_IndiceIndex];
13 	}		
14 }