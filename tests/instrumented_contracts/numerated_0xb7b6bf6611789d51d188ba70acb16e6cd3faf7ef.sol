1 pragma solidity ^0.4.21;
2 
3 contract MyToken {
4   string public name;
5   string public symbol;
6   uint8 public decimals = 18;
7   uint256 internal _totalSupply;
8   mapping (address => uint256) public balanceOf;
9   mapping (address => mapping (address => uint256)) internal _allowance;
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12   function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
13     _totalSupply = initialSupply * 10 ** uint256(decimals);
14     balanceOf[msg.sender] = totalSupply();
15     name = tokenName;
16     symbol = tokenSymbol;
17   }
18 
19   function _transfer(address _from, address _to, uint _value) internal {
20     require(_to != 0x0);
21     require(balanceOf[_from] >= _value);
22     require(balanceOf[_to] + _value > balanceOf[_to]);
23     uint previousBalances = balanceOf[_from] + balanceOf[_to];
24     balanceOf[_from] -= _value;
25     balanceOf[_to] += _value;
26     emit Transfer(_from, _to, _value);
27     assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
28   }
29 
30   function totalSupply() view returns(uint256)
31   {
32     return _totalSupply;
33   }
34 
35   function transfer(address _to, uint256 _value) public {
36     _transfer(msg.sender, _to, _value);
37   }
38 
39   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
40     require(_value <= allowance(_from,_to));
41     _allowance[_from][_to] -= _value;
42     _transfer(_from, _to, _value);
43     return true;
44   }
45 
46   function allowance(address _owner, address _spender) view returns (uint256 remaining)
47   {
48     remaining = _allowance[_owner][_spender];
49   }
50 
51   function approve(address _spender, uint256 _value) public
52   returns (bool success) {
53     _allowance[msg.sender][_spender] = _value;
54     emit Approval(msg.sender, _spender, _value);
55     return true;
56   }
57 }