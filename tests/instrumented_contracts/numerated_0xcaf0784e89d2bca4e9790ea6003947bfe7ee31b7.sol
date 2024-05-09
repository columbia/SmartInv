1 pragma solidity ^0.7.6;
2 
3 interface AvastarsContract {
4         function useTraits(uint256 _primeId, bool[12] calldata _traitFlags) external;
5         function getPrimeReplicationByTokenId(uint256 _tokenId) external view returns (uint256 tokenId, bool[12] memory replicated); 
6 }
7 
8 interface ARTContract {
9         function burnArt(uint256 artToBurn) external;
10         function transferFrom(address from, address to, uint256 value) external returns (bool);
11 }
12 
13 contract AvastarsInterface {
14     
15         constructor() {
16             Avastars = AvastarsContract(AvastarsAddress);
17             AvastarReplicantToken = ARTContract(ARTAddress);
18             owner = msg.sender;
19             setPaymentIncrement(5000000000000000);
20         }
21         
22         modifier isOwner() {
23         require(msg.sender == owner, "Must be owner of contract");
24         _;
25         }
26         
27         address public AvastarsAddress = 0xF3E778F839934fC819cFA1040AabaCeCBA01e049; //mainnet: 0xF3E778F839934fC819cFA1040AabaCeCBA01e049
28         address public ARTAddress = 0x69ad42A8726f161Bd4C76305DFa8F4ecc120115c; //mainnet: 0x69ad42A8726f161Bd4C76305DFa8F4ecc120115c
29         address public owner;
30         uint256 public paymentIncrement;
31         
32         address payable paymentWallet = 0x4C7BEdfA26C744e6bd61CBdF86F3fc4a76DCa073; //nft42 wallet: 0x4C7BEdfA26C744e6bd61CBdF86F3fc4a76DCa073
33         
34         event TraitsBurned(address msgsender, uint256 paymentTier); 
35         
36         AvastarsContract Avastars;
37         ARTContract AvastarReplicantToken;
38         
39         function burnReplicantTraits(uint256 paymentTier, uint[] memory avastarIDs, bool[12][] memory avastarTraits) public payable {
40             
41             require(msg.value >= paymentTier * paymentIncrement);
42             require(avastarIDs.length == avastarTraits.length);
43             
44             uint256 totalAvastars = avastarIDs.length;
45             
46             bool[12] memory traitIsUsed;
47             bool[12] memory traitsToBurn;
48             
49             for (uint i = 0; i < totalAvastars; i = i + 1){
50                 (, traitIsUsed) = Avastars.getPrimeReplicationByTokenId(avastarIDs[i]);
51                 traitsToBurn = avastarTraits[i];
52                 
53                 for(uint j = 0; j < 12; j = j + 1) {
54                     if(traitIsUsed[j] == true) {
55                         require(traitsToBurn[j] == false);
56                     }
57                 }
58                 
59                 Avastars.useTraits(avastarIDs[i],avastarTraits[i]);                
60             }    
61             
62             AvastarReplicantToken.transferFrom(msg.sender,address(this),1000000000000000000);
63             AvastarReplicantToken.burnArt(1);
64             paymentWallet.transfer(msg.value);
65     
66             emit TraitsBurned(msg.sender, paymentTier);
67         }
68         
69         function setPaymentIncrement(uint256 newIncrement) public isOwner {
70             paymentIncrement = newIncrement;
71         }
72         
73         function setOwner(address newOwner) public isOwner {
74             owner = newOwner;
75         }
76         
77         function setPaymentWallet(address payable newWallet) public isOwner {
78             paymentWallet = newWallet;
79         }
80         
81 }