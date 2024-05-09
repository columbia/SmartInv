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
21 contract OsmiumCrowdsale is owned {
22     
23     uint256 public totalSupply;
24     mapping (address => uint256) public balanceOf;
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     function OsmiumCrowdsale() payable owned() {
29         totalSupply = 21000000;
30         balanceOf[this] = 20000000;
31         balanceOf[owner] = totalSupply - balanceOf[this];
32         Transfer(this, owner, balanceOf[owner]);
33     }
34 
35     function () payable {
36         require(balanceOf[this] > 0);
37         uint256 tokensPerOneEther = 3000;
38         uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
39         if (tokens > balanceOf[this]) {
40             tokens = balanceOf[this];
41             uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;
42             msg.sender.transfer(msg.value - valueWei);
43         }
44         require(tokens > 0);
45         balanceOf[msg.sender] += tokens;
46         balanceOf[this] -= tokens;
47         Transfer(this, msg.sender, tokens);
48     }
49 }
50 
51 contract Osmium is OsmiumCrowdsale {
52     
53     string  public standard    = 'Token 0.1';
54     string  public name        = 'Osmium';
55     string  public symbol      = "OSM";
56     uint8   public decimals    = 0;
57 
58     function Osmium() payable OsmiumCrowdsale() {}
59 
60     function transfer(address _to, uint256 _value) public {
61         require(balanceOf[msg.sender] >= _value);
62         balanceOf[msg.sender] -= _value;
63         balanceOf[_to] += _value;
64         Transfer(msg.sender, _to, _value);
65     }
66 }
67 
68 contract EasyOsmiumCrowdsale is Osmium {
69 
70     function EasyOsmiumCrowdsale() payable Osmium() {}
71     
72     function withdraw() public onlyOwner {
73         owner.transfer(this.balance);
74     }
75     
76     function killMe() public onlyOwner {
77         selfdestruct(owner);
78     }
79 }