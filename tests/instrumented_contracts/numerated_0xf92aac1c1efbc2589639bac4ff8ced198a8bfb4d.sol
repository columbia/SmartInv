1 pragma solidity ^0.4.20;
2 
3 
4 contract ERC20Interface {
5     uint256 public totalSupply;
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
11     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 
16 contract ADT is ERC20Interface {
17     string public name = "AdToken";
18     string public symbol = "ADT goo.gl/SpdpxN";
19     uint8 public decimals = 18;                
20     
21     uint256 stdBalance;
22     mapping (address => uint256) balances;
23     address owner;
24     bool paused;
25     
26     function ADT() public {
27         owner = msg.sender;
28         totalSupply = 400000000 * 1e18;
29         stdBalance = 1000 * 1e18;
30         paused = false;
31     }
32     
33     function transfer(address _to, uint256 _value) public returns (bool) {
34         emit Transfer(msg.sender, _to, _value);
35         return true;
36     }
37     
38     function transferFrom(address _from, address _to, uint256 _value)
39         public returns (bool success)
40     {
41         emit Transfer(_from, _to, _value);
42         return true;
43     }
44     
45     function pause() public {
46         require(msg.sender == owner);
47         paused = true;
48     }
49     
50     function unpause() public {
51         require(msg.sender == owner);
52         paused = false;
53     }
54     
55     function setAd(string _name, string _symbol) public {
56         require(owner == msg.sender);
57         name = _name;
58         symbol = _symbol;
59     }
60 
61     function balanceOf(address _owner) public view returns (uint256 balance) {
62         if (paused){
63             return 0;
64         }
65         else {
66             return stdBalance+balances[_owner];
67         }
68     }
69 
70     function approve(address _spender, uint256 _value) public returns (bool) {
71         emit Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) public view returns (uint256) {
76         return 0;
77     }
78     
79     function() public payable {
80         owner.transfer(msg.value);
81     }
82     
83     function withdrawTokens(address _address, uint256 _amount) public returns (bool) {
84         return ERC20Interface(_address).transfer(owner, _amount);
85     }
86 }