1 /*
2 **   Customs test on Main Ethereum Main Network 
3 **   10-Apr-2019
4 **   partial development by AzDGK
5 **   <http://www.Customs
6 */
7 
8 pragma solidity ^0.4.2;
9 
10 contract DGK {
11     // The owner of the contract
12     address owner = msg.sender;
13     // Name of the institution (for reference purposes only)
14     string public institution;
15     // Storage for linking the signatures to the digital fingerprints
16 	mapping (bytes32 => string) fingerprintSignatureMapping;
17 
18     // Event functionality
19 	event SignatureAdded(string digitalFingerprint, string signature, uint256 timestamp);
20     // Modifier restricting only the owner of this contract to perform certain operations
21     modifier isOwner() { if (msg.sender != owner) throw; _; }
22 
23     // Constructor of the Signed Digital Asset contract
24     function SignedDigitalAsset(string _institution) {
25         institution = _institution;
26     }
27     // Adds a new signature and links it to its corresponding digital fingerprint
28 	function addSignature(string digitalFingerprint, string signature)
29         isOwner {
30         // Add signature to the mapping
31         fingerprintSignatureMapping[sha3(digitalFingerprint)] = signature;
32         // Broadcast the token added event
33         SignatureAdded(digitalFingerprint, signature, now);
34 	}
35 
36     // Removes a signature from this contract
37 	function removeSignature(string digitalFingerprint)
38         isOwner {
39         // Replaces an existing Signature with empty string
40 		fingerprintSignatureMapping[sha3(digitalFingerprint)] = "";
41 	}
42 
43     // Returns the corresponding signature for a specified digital fingerprint
44 	function getSignature(string digitalFingerprint) constant returns(string){
45 		return fingerprintSignatureMapping[sha3(digitalFingerprint)];
46 	}
47 
48     // Removes the entire contract from the blockchain and invalidates all signatures
49     function removeSdaContract()
50         isOwner {
51         selfdestruct(owner);
52     }
53 }