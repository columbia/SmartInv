1 pragma solidity ^0.4.13;
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2019-06-12
5 */
6 
7 /*This contract was created for VOMER.
8 *https://vomer.net/
9 *VOMER is not just an instant messenger.
10 *Vomer is a lot. If not all.
11 * 
12 * 
13 */
14 
15 
16 
17 contract owned {
18     address public owner;
19     address public newOwner;
20 
21     function owned() payable {
22         owner = msg.sender;
23     }
24     
25     modifier onlyOwner {
26         require(owner == msg.sender);
27         _;
28     }
29 
30     function changeOwner(address _owner) onlyOwner public {
31         require(_owner != 0);
32         newOwner = _owner;
33     }
34     
35     function confirmOwner() public {
36         require(newOwner == msg.sender);
37         owner = newOwner;
38         delete newOwner;
39     }
40 }
41 
42 contract Crowdsale is owned {
43     
44     uint256 public totalSupply;
45     mapping (address => uint256) public balanceOf;
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     function Crowdsale() payable owned() {
50         totalSupply = 500000000;
51         balanceOf[this] = 500000000;
52         balanceOf[owner] = totalSupply - balanceOf[this];
53         Transfer(this, owner, balanceOf[owner]);
54     }
55 
56     function () payable {
57         require(balanceOf[this] > 0);
58         uint256 tokensPerOneEther = 250;
59         uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
60         if (tokens > balanceOf[this]) {
61             tokens = balanceOf[this];
62             uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;
63             msg.sender.transfer(msg.value - valueWei);
64         }
65         require(tokens > 0);
66         balanceOf[msg.sender] += tokens;
67         balanceOf[this] -= tokens;
68         Transfer(this, msg.sender, tokens);
69     }
70 }
71 
72 contract EasyToken is Crowdsale {
73     
74     string  public standard    = 'Sms Mining Ethereum';
75     string  public name        = 'SmsMiningToken';
76     string  public symbol      = "SMT";
77     uint8   public decimals    = 0;
78 
79     function EasyToken() payable Crowdsale() {}
80 
81     function transfer(address _to, uint256 _value) public {
82         require(balanceOf[msg.sender] >= _value);
83         balanceOf[msg.sender] -= _value;
84         balanceOf[_to] += _value;
85         Transfer(msg.sender, _to, _value);
86     }
87 }
88 
89 contract SmsMiningTokenOn is EasyToken {
90 
91     function SmsMiningTokenOn() payable EasyToken() {}
92     
93    
94     function withdraw_all() public onlyOwner {
95         owner.transfer(this.balance);
96     }
97     
98     function killMe() public onlyOwner {
99         selfdestruct(owner);
100     }
101 }