1 pragma solidity ^0.4.2;
2 
3 
4 contract Lottery {
5 
6     /*
7      * checks only owner address is calling
8     */
9     modifier onlyOwner 
10     {
11         require(msg.sender == owner);
12          _;
13     }
14 
15     /*
16      * game vars
17     */
18     address public owner;
19 
20     uint private randomNumber;  //上一次的randomNumber会参与到下一次的随机数产生
21 
22     /*
23      * events
24     */
25     event LogRandNumberBC(uint64 taskID,uint16 randomNum);
26 
27     /*
28      * init
29     */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     function RollLottery(uint64 taskID) public
35         onlyOwner
36     {
37         uint16 randResult;
38 
39         randomNumber 	= uint(keccak256(randomNumber,taskID,block.difficulty)) * uint(blockhash(block.number - 1));
40         randResult 		= uint16(randomNumber % 1000);
41 
42         emit LogRandNumberBC(taskID,randResult);
43     }
44 
45 
46     function ()
47         public payable
48     {
49         return;
50     }
51 
52 
53     /* only owner address can set owner address */
54     function ownerChangeOwner(address newOwner) public
55         onlyOwner
56     {
57         owner = newOwner;
58     }
59 
60     /* only owner address can suicide - emergency */
61     function ownerkill() public
62         onlyOwner
63     {
64         selfdestruct(owner);
65     }
66 
67 }