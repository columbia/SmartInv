1 pragma solidity ^0.4.10;
2 
3 contract timereum {
4 
5 string public name; 
6 string public symbol; 
7 uint8 public decimals; 
8 uint256 public maxRewardUnitsAvailable;
9 uint256 public startTime;
10 uint256 public initialSupplyPerChildAddress;
11 uint256 public numImports;
12 uint256 public maxImports;
13 
14 mapping (address => uint256) public balanceOf;
15 mapping (address => bool) public parentAddress;
16 mapping (address => address) public returnChildAddressForParent;
17 mapping (address => uint256) public numRewardsUsed;
18 
19 event Transfer(address indexed from, address indexed to, uint256 value);
20 event addressesImported(address importedFrom,uint256 numPairsImported,uint256 numImported); 
21 
22 function timereum() {
23 name = "timereum";
24 symbol = "TME";
25 decimals = 18;
26 initialSupplyPerChildAddress = 1000000000000000000;
27 maxRewardUnitsAvailable=10; //10 batches
28 startTime=1500307354; //Time contract went online.
29 maxImports=107; //5 extra imports in case issues arise. All imports recorded and remaining maxImports used at end to prevent injection.
30 }
31 
32 function transfer(address _to, uint256 _value) { 
33 if (balanceOf[msg.sender] < _value) revert();
34 if (balanceOf[_to] + _value < balanceOf[_to]) revert();
35 if (parentAddress[_to])     {
36     if (msg.sender==returnChildAddressForParent[_to])  {
37         if (numRewardsUsed[msg.sender]<maxRewardUnitsAvailable)    {
38             uint256 currDate=block.timestamp;
39             uint256 returnMaxPerBatchGenerated=5000000000000000000000; //max 5000 coins per batch
40             uint256 deployTime=10*365*86400; //10 years
41             uint256 secondsSinceStartTime=currDate-startTime;
42             uint256 maximizationTime=deployTime+startTime;
43             uint256 coinsPerBatchGenerated;
44             if (currDate>=maximizationTime)  {
45                 coinsPerBatchGenerated=returnMaxPerBatchGenerated;
46             } else  {
47                 uint256 b=(returnMaxPerBatchGenerated/4);
48                 uint256 m=(returnMaxPerBatchGenerated-b)/deployTime;
49                 coinsPerBatchGenerated=secondsSinceStartTime*m+b;
50             }
51             numRewardsUsed[msg.sender]+=1;
52             balanceOf[msg.sender]+=coinsPerBatchGenerated;
53         }
54     }
55 }
56 balanceOf[msg.sender] -= _value;
57 balanceOf[_to] += _value;
58 Transfer(msg.sender, _to, _value); 
59 }
60 
61 //Storage of addresses is broken into smaller contracts.
62 function importAddresses(address[] parentsArray,address[] childrenArray)	{
63 	if (numImports<maxImports)	{
64 		numImports++;
65 		addressesImported(msg.sender,childrenArray.length,numImports); //Details of import
66 		balanceOf[0x000000000000000000000000000000000000dEaD]=numImports*initialSupplyPerChildAddress; //Easy way for people to check numImports without debugger after launch.
67 		for (uint i=0;i<childrenArray.length;i++)   {
68 				address child=childrenArray[i];
69 				address parent=parentsArray[i];
70 				parentAddress[parent]=true;
71 				returnChildAddressForParent[parent]=child;
72 				balanceOf[child]=initialSupplyPerChildAddress;
73 		}
74 	}
75 }
76 }