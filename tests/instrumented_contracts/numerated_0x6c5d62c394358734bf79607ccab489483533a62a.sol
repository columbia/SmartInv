1 pragma solidity ^0.4.0;
2 
3 
4 contract Ownable {
5     address public owner;
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract ERC20Basic {
25     function totalSupply() public view returns (uint256);
26     function balanceOf(address who) public view returns (uint256);
27     function transfer(address to, uint256 value) public returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 
31 contract SimpleExchange is Ownable {
32 
33     ERC20Basic public token;
34     uint256 public rate;
35 
36     function SimpleExchange(address _token, uint256 _rate) public {
37         setToken(_token);
38         setRate(_rate);
39     }
40 
41     function setToken(address _token) public onlyOwner {
42         require(_token != 0);
43         token = ERC20Basic(_token);
44     }
45 
46     function setRate(uint256 _rate) public onlyOwner {
47         require(_rate != 0);
48         rate = _rate;
49     }
50 
51     function buy() public payable {
52         uint256 tokensAmount = msg.value * rate;
53         token.transfer(msg.sender, tokensAmount);
54     }
55     
56     function buy(address target, bytes _data) public payable {
57         uint256 tokensAmount = msg.value * rate;
58         token.transfer(target, tokensAmount);
59         require(target.call(_data));
60     }
61 
62     function claim() public onlyOwner {
63         owner.transfer(this.balance);
64     }
65 
66     function claimTokens() public onlyOwner {
67         token.transfer(owner, token.balanceOf(this));
68     }
69 
70 }