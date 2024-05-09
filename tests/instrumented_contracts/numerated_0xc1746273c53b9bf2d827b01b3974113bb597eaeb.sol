1 pragma solidity ^0.4.4;
2 
3 contract EtownCoinTest {
4   string public standard = 'ERC20';
5   string public name;
6   string public symbol;
7   uint8 public decimals;
8   uint256 public totalSupply;
9 
10   mapping (address => uint256) public balanceOf;
11   mapping (address => mapping (address => uint256)) public allowance;
12 
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 
15   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17   function EtownCoinTest(
18     uint256 initialSupply,
19     string tokenName,
20     uint8 decimalUnits,
21     string tokenSymbol
22     ) {
23     balanceOf[msg.sender] = initialSupply;
24     totalSupply = initialSupply;
25     name = tokenName;
26     symbol = tokenSymbol;
27     decimals = decimalUnits;
28   }
29 
30   function transfer(address _to, uint256 _value) {
31     if (_to == 0x0) revert();
32     if (balanceOf[msg.sender] < _value) revert();
33     if (balanceOf[_to] + _value < balanceOf[_to]) revert();
34     balanceOf[msg.sender] -= _value;
35     balanceOf[_to] += _value;
36     Transfer(msg.sender, _to, _value);
37   }
38 
39   function approve(address _spender, uint256 _value)
40     returns (bool success) {
41     allowance[msg.sender][_spender] = _value;
42     Approval(msg.sender, _spender, _value);
43     success = true;
44   }    
45 
46   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
47     if (_to == 0x0) revert();
48     if (balanceOf[_from] < _value) revert();
49     if (balanceOf[_to] + _value < balanceOf[_to]) revert();
50     balanceOf[_from] -= _value;
51     balanceOf[_to] += _value;
52     allowance[_from][msg.sender] -= _value;
53     Transfer(_from, _to, _value);
54     success = true;
55   }
56 }