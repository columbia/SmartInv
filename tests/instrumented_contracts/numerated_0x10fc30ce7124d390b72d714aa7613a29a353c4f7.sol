1 pragma solidity ^0.4.11;
2 
3 /// @title Artcoin (ART) - democratizing culture.
4 contract Artcoin {
5 
6     string public constant name = "Artcoin";
7     string public constant symbol = "ART";
8     uint8 public constant decimals = 18;
9 
10     uint256 public authorizedSupply;
11     uint256 public treasurySupply;
12 
13     mapping (address => uint) public balances;
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16 
17     /*
18      * Initialize Artcoin.
19      */
20     function Artcoin(address consortium, uint256 _authorizedSupply, uint256 _treasurySupply) {
21         authorizedSupply = _authorizedSupply;
22         treasurySupply = _treasurySupply;
23         if (authorizedSupply < treasurySupply) throw;
24 
25         // one-time issuance of ART to the consortium endowment
26         balances[consortium] = authorizedSupply;
27 
28         // one-time issuance of ART to the consortium founders
29         var founderSupply = ((authorizedSupply - treasurySupply) / 2) / 2;
30         balances[0x00331BA52fa3A22d6C7904Be8910954184336bcc] = founderSupply;
31         balances[0x210DdB647768B891472700CaE03043003A79384E] = founderSupply;
32 
33         balances[consortium] -= founderSupply * 2;
34     }
35 
36     /// @return total amount of ART
37     function totalSupply() external constant returns (uint256) {
38         return authorizedSupply;
39     }
40 
41     /// @param _owner The address from which the ART balance will be retrieved
42     /// @return The balance
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     /// @notice send `_value` ART to `_to` from `msg.sender`
48     /// to provided account address `_to`.
49     /// @param _to The address of the ART recipient
50     /// @param _value The amount of ART to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) returns (bool) {
53         var senderBalance = balances[msg.sender];
54         var overflow = balanceOf(_to) + _value < balanceOf(_to);
55         if (_value > 0 && senderBalance >= _value && !overflow) {
56             senderBalance -= _value;
57             balances[msg.sender] = senderBalance;
58             balances[_to] += _value;
59             Transfer(msg.sender, _to, _value);
60             return true;
61         }
62         return false;
63     }
64 }