1 pragma solidity ^0.4.11;
2 
3 contract ERC20Standard {
4  uint public totalSupply;
5  
6  string public name;
7  uint8 public decimals;
8  string public symbol;
9  string public version;
10  
11  mapping (address => uint256) balances;
12  mapping (address => mapping (address => uint)) allowed;
13 
14  //Fix for short address attack against ERC20
15  modifier onlyPayloadSize(uint size) {
16   assert(msg.data.length == size + 4);
17   _;
18  } 
19 
20  function balanceOf(address _owner) constant returns (uint balance) {
21   return balances[_owner];
22  }
23 
24  function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {
25   require(balances[msg.sender] >= _value && _value > 0);
26      balances[msg.sender] -= _value;
27      balances[_recipient] += _value;
28      Transfer(msg.sender, _recipient, _value);        
29     }
30 
31  function transferFrom(address _from, address _to, uint _value) {
32   require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
33         balances[_to] += _value;
34         balances[_from] -= _value;
35         allowed[_from][msg.sender] -= _value;
36         Transfer(_from, _to, _value);
37     }
38 
39  function approve(address _spender, uint _value) {
40   allowed[msg.sender][_spender] = _value;
41   Approval(msg.sender, _spender, _value);
42  }
43 
44  function allowance(address _spender, address _owner) constant returns (uint balance) {
45   return allowed[_owner][_spender];
46  }
47 
48  //Event which is triggered to log all transfers to this contract's event log
49  event Transfer(
50   address indexed _from,
51   address indexed _to,
52   uint _value
53   );
54   
55  //Event which is triggered whenever an owner approves a new allowance for a spender.
56  event Approval(
57   address indexed _owner,
58   address indexed _spender,
59   uint _value
60   );
61 
62 }
63 contract NewToken is ERC20Standard {
64  function NewToken() {
65   totalSupply = 10000000000000000000000000000;
66   name = "Fext Coin";
67   decimals = 18;
68   symbol = "FEXT";
69   version = "1.0";
70   balances[msg.sender] = totalSupply;
71  }
72 }