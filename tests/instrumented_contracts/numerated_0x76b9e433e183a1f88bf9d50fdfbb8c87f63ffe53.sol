1 pragma solidity ^0.4.0;
2 
3 contract owned {
4 
5     address public owner;
6 
7     function owned() payable {
8         owner = msg.sender;
9     }
10     
11     modifier onlyOwner {
12         require(owner == msg.sender);
13         _;
14     }
15 
16     function changeOwner(address _owner) onlyOwner public {
17         owner = _owner;
18     }
19 }
20 
21 contract Crowdsale is owned {
22     
23     uint256 public totalSupply;
24     mapping (address => uint256) public balanceOf;
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     function Crowdsale() payable owned() {
29         totalSupply = 10000000 * 1 ether;
30         balanceOf[this] = 5500000 * 1 ether;
31         balanceOf[owner] = totalSupply - balanceOf[this];
32         Transfer(this, owner, balanceOf[owner]);
33     }
34 
35     function () payable {
36         require(balanceOf[this] > 0);
37         uint256 tokensPerOneEther = 1000;
38         //uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
39         uint256 tokens = tokensPerOneEther * msg.value ;
40         if (tokens > balanceOf[this]) {
41             tokens = balanceOf[this];
42             uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;
43             msg.sender.transfer(msg.value - valueWei);
44         }
45         require(tokens > 0);
46         balanceOf[msg.sender] += tokens;
47         balanceOf[this] -= tokens;
48         Transfer(this, msg.sender, tokens);
49     }
50 }
51 
52 contract EnterRentToken is Crowdsale {
53     
54     string  public standard    = 'Token 1.3';
55     string  public name        = 'Enter Rent Token';
56     string  public symbol      = "ERT";
57     uint8   public decimals    = 18;
58 
59     function EnterRentToken() payable Crowdsale() {}
60 
61     function transfer(address _to, uint256 _value) public {
62         require(balanceOf[msg.sender] >= _value);
63         balanceOf[msg.sender] -= _value;
64         balanceOf[_to] += _value;
65         Transfer(msg.sender, _to, _value);
66     }
67     
68 }
69 
70 
71 contract EnterRentCrowdsale is EnterRentToken {
72 
73     function EnterRentCrowdsale() payable EnterRentToken() {}
74     
75    function withdraw() public onlyOwner {
76     msg.sender.transfer(this.balance);
77   }
78     
79 
80     function killMe() public onlyOwner {
81         selfdestruct(owner);
82     }
83 }