1 pragma solidity ^0.4.24;
2 
3 contract owned {
4 
5     address public owner;
6     address public newOwner;
7 
8     constructor() public payable {
9         owner = msg.sender;
10     }
11     
12     modifier onlyOwner {
13         require(owner == msg.sender);
14         _;
15     }
16 
17     function changeOwner(address _owner) onlyOwner public {
18         newOwner = _owner;
19     }
20 
21     function confirmOwner() public {
22         require(newOwner == msg.sender);
23         owner = newOwner;
24     }
25 }
26 
27 contract Crowdsale is owned {
28     
29     uint256 public totalSupply;
30     string public priceOneTokenSokol = "1 token SOKOL = 0.01 ETH";
31     mapping (address => uint256) public balanceOf;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Burn(address indexed from, uint256 value);
35 
36     constructor() public payable owned() {
37         totalSupply = 11000000;
38         balanceOf[this] = 10000000;
39         balanceOf[owner] = totalSupply - balanceOf[this];
40         emit Transfer(this, owner, balanceOf[owner]);
41     }
42 
43     function () public payable {
44         require(balanceOf[this] > 0);
45         uint amountOfTokensForOneEther = 100;
46         uint256 tokens = amountOfTokensForOneEther * msg.value / 1000000000000000000;
47         if (tokens > balanceOf[this]) {
48             tokens = balanceOf[this];
49             uint256 valueWei = tokens * 1000000000000000000 / amountOfTokensForOneEther;
50             msg.sender.transfer(msg.value - valueWei);
51         }
52         require(tokens > 0);
53         balanceOf[msg.sender] += tokens;
54         balanceOf[this] -= tokens;
55         emit Transfer(this, msg.sender, tokens);
56     }
57 
58     function burn(uint256 _value) public returns (bool success) {
59         require(balanceOf[this] >= _value);
60         balanceOf[this] -= _value;
61         totalSupply -= _value;
62         emit Burn(this, _value);
63         return true;
64     }
65 }
66 
67 contract Token is Crowdsale {
68     
69     string  public name        = "Sokolov Coin";
70     string  public symbol      = "SOKOL";
71     uint8   public decimals    = 0;
72 
73     constructor() public payable Crowdsale() {}
74 
75     function transfer(address _to, uint256 _value) public {
76 	require(_to != address(0));
77         require(balanceOf[msg.sender] >= _value);
78         require(balanceOf[_to] + _value >= balanceOf[_to]);
79         balanceOf[msg.sender] -= _value;
80         balanceOf[_to] += _value;
81         emit Transfer(msg.sender, _to, _value);
82     }
83 }
84 
85 contract SokolCrowdsale is Token {
86 
87     constructor() public payable Token() {}
88     
89     function withdraw() public onlyOwner {
90         owner.transfer(address(this).balance);
91     }
92 }