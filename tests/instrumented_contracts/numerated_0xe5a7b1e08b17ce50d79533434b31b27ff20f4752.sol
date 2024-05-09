1 /*the first insurance token who will makes a minimum price for anycoin 
2 this project is for youri namicazi ITNdev 
3 */
4 pragma solidity ^0.4.21;
5 
6 
7 contract insurance_Token  {
8      uint256 public totalSupply;
9 
10     // solhint-disable-next-line no-simple-event-func-name
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 
14     uint256 constant private MAX_UINT256 = 2**256 - 1;
15     mapping (address => uint256) public balances;
16     mapping (address => mapping (address => uint256)) public allowed;
17     /*
18     NOTE:
19     The following variables are OPTIONAL vanities. One does not have to include them.
20     They allow one to customise the token contract & in no way influences the core functionality.
21     Some wallets/interfaces might not even bother to look at this information.
22     */
23     string public name;                   //fancy name: eg insurance_Token
24     uint8 public decimals;                //How many decimals to show.
25     string public symbol;                 //An identifier: eg ITN
26 
27     function insurance_Token() public {
28         balances[msg.sender] = 10000000000000000;               // Give the creator all initial tokens
29         totalSupply = 10000000000000000;                        // Update total supply
30         name = "insurance_Token";                                   // Set the name for display purposes
31         decimals = 8;                            // Amount of decimals for display purposes
32         symbol = "ITN";                               // Set the symbol for display purposes
33     }
34 
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         require(balances[msg.sender] >= _value );
37         
38         balances[msg.sender] -= _value;
39         balances[_to] += _value;
40         emit Transfer(msg.sender, _to, _value); 
41         return true;
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         uint256 allowance = allowed[_from][msg.sender];
46         require(balances[_from] >= _value && allowance >= _value && _value > 0 );
47         balances[_to] += _value;
48         balances[_from] -= _value;
49         if (allowance < MAX_UINT256) {
50             allowed[_from][msg.sender] -= _value;
51         }
52         emit Transfer(_from, _to, _value); 
53         return true;
54     }
55 
56     function balanceOf(address _owner) public view returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60     function approve(address _spender, uint256 _value) public returns (bool success) {
61         allowed[msg.sender][_spender] = _value;
62         emit Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
67         return allowed[_owner][_spender];
68     }
69 }