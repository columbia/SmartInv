1 pragma solidity ^0.4.21;
2 
3 contract FlowNet {
4 
5   mapping (address => uint256) public balances;
6   mapping (address => mapping (address => uint256)) public allowed;
7 
8   string public name = 'FlowNet';
9   uint8 public decimals = 18;
10   string public symbol = 'FNT';
11 
12   uint256 public totalSupply = 20000*10000 * 1000*1000*1000 * 1000*1000*1000;
13 
14   event Transfer(address indexed _from, address indexed _to, uint256 _value);
15   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17   constructor() public {
18     balances[msg.sender] = totalSupply;
19   }
20 
21   /// @return total amount of tokens
22   function totalSupply() public view returns (uint256 remaining) {
23     return totalSupply;
24   }
25 
26   function transfer(address _to, uint256 _value) public returns (bool success) {
27     require(balances[msg.sender] >= _value);
28     balances[msg.sender] -= _value;
29     balances[_to] += _value;
30     emit Transfer(msg.sender, _to, _value);
31     return true;
32   }
33 
34   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
35     uint256 allowance = allowed[_from][msg.sender];
36     require(balances[_from] >= _value && allowance >= _value);
37     balances[_to] += _value;
38     balances[_from] -= _value;
39     allowed[_from][msg.sender] -= _value;
40     emit Transfer(_from, _to, _value);
41     return true;
42   }
43 
44   function balanceOf(address _owner) public view returns (uint256 balance) {
45     return balances[_owner];
46   }
47 
48   function approve(address _spender, uint256 _value) public returns (bool success) {
49     allowed[msg.sender][_spender] = _value;
50     emit Approval(msg.sender, _spender, _value);
51     return true;
52   }
53 
54   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
55     return allowed[_owner][_spender];
56   }
57 }