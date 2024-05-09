1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 contract Ownable {
6 
7   address public owner;
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11   constructor() {
12     owner = msg.sender;
13     emit OwnershipTransferred(address(0), owner);
14   }
15 
16   modifier onlyOwner() {
17     require(isOwner(), "Ownable: caller is not the owner");
18     _;
19   }
20 
21   function isOwner() public view returns (bool) {
22     return msg.sender == owner;
23   }
24 
25   function renounceOwnership() public onlyOwner {
26     emit OwnershipTransferred(owner, address(0));
27     owner = address(0);
28   }
29 
30   function transferOwnership(address newOwner) public onlyOwner {
31     _transferOwnership(newOwner);
32   }
33 
34   function _transferOwnership(address newOwner) internal {
35     require(newOwner != address(0), "Ownable: new owner is the zero address");
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 }
40 
41 contract ERC20 is Ownable {
42 
43   event Transfer(address indexed from, address indexed to, uint value);
44   event Approval(address indexed owner, address indexed spender, uint value);
45 
46   mapping (address => uint) public balanceOf;
47   mapping (address => mapping (address => uint)) public allowance;
48 
49   string public name;
50   string public symbol;
51   uint8 public decimals;
52   uint public totalSupply;
53 
54   constructor(
55     string memory _name,
56     string memory _symbol,
57     uint8 _decimals
58   ) {
59     name = _name;
60     symbol = _symbol;
61     decimals = _decimals;
62     require(decimals > 0, "decimals");
63   }
64 
65   function transfer(address _recipient, uint _amount) public returns (bool) {
66     _transfer(msg.sender, _recipient, _amount);
67     return true;
68   }
69 
70   function approve(address _spender, uint _amount) public returns (bool) {
71     _approve(msg.sender, _spender, _amount);
72     return true;
73   }
74 
75   function transferFrom(address _sender, address _recipient, uint _amount) public returns (bool) {
76     require(allowance[_sender][msg.sender] >= _amount, "ERC20: insufficient approval");
77     _transfer(_sender, _recipient, _amount);
78     _approve(_sender, msg.sender, allowance[_sender][msg.sender] - _amount);
79     return true;
80   }
81 
82   function _transfer(address _sender, address _recipient, uint _amount) internal {
83     require(_sender != address(0), "ERC20: transfer from the zero address");
84     require(_recipient != address(0), "ERC20: transfer to the zero address");
85     require(balanceOf[_sender] >= _amount, "ERC20: insufficient funds");
86 
87     balanceOf[_sender] -= _amount;
88     balanceOf[_recipient] += _amount;
89     emit Transfer(_sender, _recipient, _amount);
90   }
91 
92   function mint(address _account, uint _amount) public onlyOwner {
93     _mint(_account, _amount);
94   }
95 
96   function burn(address _account, uint _amount) public onlyOwner {
97     _burn(_account, _amount);
98   }
99 
100   function _mint(address _account, uint _amount) internal {
101     require(_account != address(0), "ERC20: mint to the zero address");
102 
103     totalSupply += _amount;
104     balanceOf[_account] += _amount;
105     emit Transfer(address(0), _account, _amount);
106   }
107 
108   function _burn(address _account, uint _amount) internal {
109     require(_account != address(0), "ERC20: burn from the zero address");
110 
111     balanceOf[_account] -= _amount;
112     totalSupply -= _amount;
113     emit Transfer(_account, address(0), _amount);
114   }
115 
116   function _approve(address _owner, address _spender, uint _amount) internal {
117     require(_owner != address(0), "ERC20: approve from the zero address");
118     require(_spender != address(0), "ERC20: approve to the zero address");
119 
120     allowance[_owner][_spender] = _amount;
121     emit Approval(_owner, _spender, _amount);
122   }
123 }