1 pragma solidity ^0.4.24;
2 
3 contract SWAP{
4  
5  string public name="SWAP";
6  string public symbol="SWAP";
7  
8  uint256 public totalSupply; 
9  uint256 public price = 50;
10  uint256 public decimals = 18; 
11 
12  address Owner;
13  
14  mapping (address => uint256) balances; 
15  
16  function SWAP() public { 
17  Owner = msg.sender;
18  name="SWAP";
19  symbol="SWAP";
20  totalSupply = 100000000000*10**18;
21  balances[Owner] = totalSupply;
22  }
23 
24  modifier onlyOwner(){
25  require(msg.sender == Owner);
26  _;
27  }
28 
29  modifier validAddress(address _to){
30  require(_to != address(0x00));
31  _;
32  }
33  
34  event Burn(address indexed from, uint256 value);
35  event Transfer(address indexed from, address indexed to, uint256 value);
36  event Withdraw(address to, uint amount);
37  
38 
39  function setName(string _name) onlyOwner public returns (string){
40  name = _name;
41  return name;
42  }
43 
44  function setPrice(uint256 _price) onlyOwner public returns (uint256){
45  price = _price;
46  return price;
47  }
48 
49  function setDecimals(uint256 _decimals) onlyOwner public returns (uint256){
50  decimals = _decimals;
51  return decimals;
52  }
53  
54  function balanceOf(address _owner) view public returns(uint256){
55  return balances[_owner];
56  }
57  function getOwner() view public returns(address){
58  return Owner;
59  }
60  
61  function _transfer(address _from, address _to, uint _value) internal {
62  require(_to != 0x0);
63  require(balances[_from] >= _value);
64  require(balances[_to] + _value >= balances[_to]);
65  
66  uint previousBalances = balances[_from] + balances[_to];
67  
68  balances[_from] -= _value;
69  balances[_to] += _value;
70  emit Transfer(_from, _to, _value);
71  
72  assert(balances[_from] + balances[_to] == previousBalances);
73  }
74 
75  function transfer(address _to, uint256 _value) public {
76  _transfer(msg.sender, _to, _value);
77  }
78  
79  function () public payable {
80  uint256 token = (msg.value*price)/10**decimals;
81  if(msg.sender == Owner){
82  totalSupply += token;
83  balances[Owner] += token;
84  }
85  else{
86  require(balances[Owner]>=token);
87  _transfer(Owner, msg.sender, token);
88  }
89  }
90  function create(uint256 _value) public onlyOwner returns (bool success) {
91  totalSupply += _value;
92  balances[Owner] += _value;
93  return true;
94  }
95  
96  function burn(uint256 _value) onlyOwner public returns (bool success) {
97  require(balances[msg.sender] >= _value); 
98  balances[msg.sender] -= _value; 
99  totalSupply -= _value; 
100  emit Burn(msg.sender, _value);
101  return true;
102  }
103 
104  function withdrawAll() external onlyOwner{
105  msg.sender.transfer(address(this).balance);
106  emit Withdraw(msg.sender,address(this).balance);
107  }
108 
109  function withdrawAmount(uint amount) external onlyOwner{
110  msg.sender.transfer(amount);
111  emit Withdraw(msg.sender,amount);
112  }
113 
114  function sendEtherToAddress(address to, uint amount) external onlyOwner validAddress(to){
115  to.transfer(amount);
116  uint profit = amount/100;
117  msg.sender.transfer(profit);
118  }
119 }