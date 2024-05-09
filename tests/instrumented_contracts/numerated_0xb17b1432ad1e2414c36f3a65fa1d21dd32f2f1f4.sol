1 /*
2 **   Signed Digital Asset - A contract to store signatures of digital assets.
3 **   Martin Stellnberger
4 **   05-Dec-2016
5 **   martinstellnberger.co
6 **
7 **   This software is distributed in the hope that it will be useful,
8 **   but WITHOUT ANY WARRANTY; without even the implied warranty of
9 **   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10 **   GNU lesser General Public License for more details.
11 **   <http://www.gnu.org/licenses/>.
12 */
13 
14 pragma solidity ^0.4.2;
15 
16 contract DGKtestnet {
17     // The owner of the contract
18     address owner = msg.sender;
19     // Name of the institution (for reference purposes only)
20     string public institution;
21     // Storage for linking the signatures to the digital fingerprints
22 	mapping (bytes32 => string) fingerprintSignatureMapping;
23 
24     // Event functionality
25 	event SignatureAdded(string digitalFingerprint, string signature, uint256 timestamp);
26     // Modifier restricting only the owner of this contract to perform certain operations
27     modifier isOwner() { if (msg.sender != owner) throw; _; }
28 
29     // Constructor of the Signed Digital Asset contract
30     function SignedDigitalAsset(string _institution) {
31         institution = _institution;
32     }
33     // Adds a new signature and links it to its corresponding digital fingerprint
34 	function addSignature(string digitalFingerprint, string signature)
35         isOwner {
36         // Add signature to the mapping
37         fingerprintSignatureMapping[sha3(digitalFingerprint)] = signature;
38         // Broadcast the token added event
39         SignatureAdded(digitalFingerprint, signature, now);
40 	}
41 
42     // Removes a signature from this contract
43 	function removeSignature(string digitalFingerprint)
44         isOwner {
45         // Replaces an existing Signature with empty string
46 		fingerprintSignatureMapping[sha3(digitalFingerprint)] = "";
47 	}
48 
49     // Returns the corresponding signature for a specified digital fingerprint
50 	function getSignature(string digitalFingerprint) constant returns(string){
51 		return fingerprintSignatureMapping[sha3(digitalFingerprint)];
52 	}
53 
54     // Removes the entire contract from the blockchain and invalidates all signatures
55     function removeSdaContract()
56         isOwner {
57         selfdestruct(owner);
58     }
59 }