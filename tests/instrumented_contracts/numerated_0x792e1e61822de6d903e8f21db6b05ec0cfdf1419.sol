1 pragma solidity ^0.4.11;
2 
3 contract ERC20Constant {
4     function balanceOf( address who ) constant returns (uint value);
5 }
6 contract ERC20Stateful {
7     function transfer( address to, uint value) returns (bool ok);
8 }
9 contract ERC20Events {
10     event Transfer(address indexed from, address indexed to, uint value);
11 }
12 contract ERC20 is ERC20Constant, ERC20Stateful, ERC20Events {}
13 
14 contract Owned {
15     address public owner;
16 
17     function Owned() {
18         owner = msg.sender;
19     }
20 
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     function transferOwnership(address newOwner) onlyOwner {
27         owner = newOwner;
28     }
29 }
30 
31 contract ClosedSale is Owned {
32 
33     ERC20 public token;
34 
35     // Amount of Token received per ETH
36     uint256 public tokenPerEth;
37 
38     // Address that can buy the Token
39     address public buyer;
40 
41     // Forwarding address
42     address public receiver;
43 
44     event LogWithdrawal(uint256 _value);
45     event LogBought(uint _value);
46 
47     function ClosedSale (
48         ERC20   _token,
49         address _buyer,
50         uint256 _tokenPerEth,
51         address _receiver
52     )
53         Owned()
54     {
55         token       = _token;
56         receiver    = _receiver;
57         buyer       = _buyer;
58         tokenPerEth = _tokenPerEth;
59     }
60 
61     // Withdraw the token
62     function withdrawToken(uint256 _value) onlyOwner returns (bool ok) {
63         return ERC20(token).transfer(owner,_value);
64         LogWithdrawal(_value);
65     }
66 
67     function buy(address beneficiary) payable {
68         require(beneficiary == buyer);
69 
70         uint orderInTokens = msg.value * tokenPerEth;
71         token.transfer(beneficiary, orderInTokens);
72         receiver.transfer(msg.value);
73 
74         LogBought(orderInTokens);
75     }
76 
77     function() payable {
78         buy(msg.sender);
79     }
80 }