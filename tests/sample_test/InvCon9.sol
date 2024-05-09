1 pragma solidity ^0.4.4;

2 contract Token {

3     function totalSupply() constant returns (uint256 supply) {}
4     function balanceOf(address _owner) constant returns (uint256 balance) {}

5     function transfer(address _to, uint256 _value) returns (bool success) {}

6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}

  
7     function approve(address _spender, uint256 _value) returns (bool success) {}


8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}

9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }



12 contract StandardToken is Token {

13     function transfer(address _to, uint256 _value) returns (bool success) {
   
14         if (balances[msg.sender] >= _value && _value > 0) {
15             balances[msg.sender] -= _value;
16             balances[_to] += _value;
17             Transfer(msg.sender, _to, _value);
18             return true;
19         } else { return false; }
20     }

21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
   
22         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
23             balances[_to] += _value;
24             balances[_from] -= _value;
25             allowed[_from][msg.sender] -= _value;
26             Transfer(_from, _to, _value);
27             return true;
28         } else { return false; }
29     }

30     function balanceOf(address _owner) constant returns (uint256 balance) {
31         return balances[_owner];
32     }

33     function approve(address _spender, uint256 _value) returns (bool success) {
34         allowed[msg.sender][_spender] = _value;
35         Approval(msg.sender, _spender, _value);
36         return true;
37     }

38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
39         return allowed[_owner][_spender];
40     }

41     mapping (address => uint256) balances;
42     mapping (address => mapping (address => uint256)) allowed;
43     uint256 public totalSupply;
44 }

45 contract ERC20Token is StandardToken {

46     function () {
47         //if ether is sent to this address, send it back.
48         throw;
49     }

50     /* Public variables of the token */
51     string public name;                   //Name of the token
52     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals
53     string public symbol;                 //An identifier: eg AXM
54     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.



55 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token

56     function ERC20Token(
57         ) {
58         balances[msg.sender] = 85000000000000;               // Give the creator all initial tokens (100000 for example)
59         totalSupply = 85000000000000;                        // Update total supply (100000 for example)
60         name = "GAIN CHAIN";                                   // Set the name for display purposes
61         decimals = 8;                            // Amount of decimals
62         symbol = "GAIN";                               // Set the symbol for display purposes
63     }


64     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);

67         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
68         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
69         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
70         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
71         return true;
72     }