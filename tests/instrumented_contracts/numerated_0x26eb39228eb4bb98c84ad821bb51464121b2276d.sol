1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4     address public owner;
5     function Ownable() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner() {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 
17 contract NAUTokenCoin is Ownable {
18     string public constant name = "eNAU";
19     string public constant symbol = "ENAU";
20     uint32 public constant decimals = 4;
21     uint public constant INITIAL_SUPPLY = 12850000000000;
22     uint public totalSupply = 0;
23     mapping (address => uint) balances;
24     mapping (address => mapping(address => uint)) allowed;
25     function NAUTokenCoin () public {
26         totalSupply = INITIAL_SUPPLY;
27         balances[msg.sender] = INITIAL_SUPPLY;
28     }
29     function balanceOf(address _owner) public constant returns (uint balance) {
30         return balances[_owner];
31     }
32     function transfer(address _to, uint _value) public returns (bool success) {
33         if(balances[msg.sender] >= _value && balances[msg.sender] + _value >= balances[msg.sender]) {
34             balances[msg.sender] -= _value;
35             balances[_to] += _value;
36             Transfer(msg.sender, _to, _value);
37             return true;
38         }
39         return false;
40     }
41     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
42         if (allowed[_from][msg.sender] >= _value && balances[_from] >= _value && balances[_to] + _value >= balances[_to]) {
43             allowed[_from][msg.sender] -= _value;
44             balances[_from] -= _value;
45             balances[_to] += _value;
46             Transfer(_from, _to, _value);
47             return true;
48         }
49         return false;
50     }
51     function approve(address _spender, uint _value) public returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
57         return allowed[_owner][_spender];
58     }
59     event Transfer(address indexed _from, address indexed _to, uint _value);
60     event Approval(address indexed _owner, address indexed _spender, uint _value);
61 }