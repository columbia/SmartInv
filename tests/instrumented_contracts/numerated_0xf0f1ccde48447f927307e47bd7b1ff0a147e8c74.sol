1 pragma solidity 0.5.1;
2 contract zDappRunner {  
3 	address payable gadrOwner;
4 	uint32 gnEntryCount = 0;
5 
6 	struct clsEntry {
7 		address adrCreator;
8 		bool bDisabled;
9 	}
10 
11 	mapping(bytes32 => clsEntry) gmapEntry;
12 	mapping (uint => bytes32) gmapEntryIndex;
13 
14 	constructor() public { gadrOwner = msg.sender; }
15 
16 	modifier onlyByOwner()
17 	{
18 		require(
19 			msg.sender == gadrOwner, "Sender not authorized."
20 		);
21 		_;
22 	}
23 
24 	event Entries(bytes32 indexed b32AlphaID, address indexed adrCreator, uint indexed nDateCreated, string sParms);
25 
26 	function zKill() onlyByOwner() external {selfdestruct (gadrOwner);}
27 	
28 	function zGetAllEntries() external view returns (bytes32[] memory ab32AlphaID, address[] memory aadrCreator, bool[] memory abDisabled) {
29 		ab32AlphaID = new bytes32[](gnEntryCount);
30 		aadrCreator = new address[](gnEntryCount);
31 		abDisabled = new bool[](gnEntryCount);
32 	
33 		for (uint i = 0; i < gnEntryCount; i++) {
34 			clsEntry memory objEntry = gmapEntry[gmapEntryIndex[i]];
35 			ab32AlphaID[i] = gmapEntryIndex[i];
36 			aadrCreator[i] = objEntry.adrCreator;
37 			abDisabled[i] = objEntry.bDisabled;
38 		}	
39 	}
40 
41 	function zAddEntry(bytes32 b32AlphaID, string calldata sParms) external {
42 		gmapEntry[b32AlphaID].adrCreator = msg.sender;
43 		gmapEntryIndex[gnEntryCount] = b32AlphaID;
44 		gnEntryCount++;
45 		emit Entries(b32AlphaID, msg.sender, block.timestamp, sParms);
46 	}
47 
48 	function zSetDisabled(bytes32 b32AlphaID, bool bDisabled) external {
49 		require(msg.sender == gadrOwner || msg.sender == gmapEntry[b32AlphaID].adrCreator);
50 		gmapEntry[b32AlphaID].bDisabled = bDisabled;
51 	}
52 }