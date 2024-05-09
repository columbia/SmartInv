1 pragma solidity ^0.4.19;
2 
3 /* Function required from STCn main contract */
4 contract ERC20Token {
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {}
6     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
7     
8 }
9 
10 contract MultiSend {
11     ERC20Token public _STCnContract;
12     address public _multiSendOwner;
13     uint256 public tokensApproved;
14     
15     function MultiSend () {
16         address c = 0x420C42cE1370c0Ec3ca87D9Be64A7002E78e6709; // set STCn contract address
17         _STCnContract = ERC20Token(c); 
18         _multiSendOwner = msg.sender;
19         tokensApproved = 0; // set to 0 first as allowance to contract can't be set yet
20     }
21     
22     /* Before first sending, make sure to allow this contract spending from token contract with function approve(address _spender, uint256 _value)
23     ** and to update tokensApproved with function updateTokensApproved () */
24     
25     function dropCoinsSingle(address[] dests, uint256 tokens) {
26         require(msg.sender == _multiSendOwner && tokensApproved >= (dests.length * tokens));
27         uint256 i = 0;
28         while (i < dests.length) {
29             _STCnContract.transferFrom(_multiSendOwner, dests[i], tokens);
30             i += 1;
31         }
32         updateTokensApproved();
33     }
34     
35     /* Be careful to this function to be sure you approved enough before you send as contract can't check first total amount in array
36     ** If not enough amount is approved, transaction will fail */
37     
38     function dropCoinsMulti(address[] dests, uint256[] tokens) {
39         require(msg.sender == _multiSendOwner);
40         uint256 i = 0;
41         while (i < dests.length) {
42             _STCnContract.transferFrom(_multiSendOwner, dests[i], tokens[i]);
43             i += 1;
44         }
45         updateTokensApproved();
46     }
47     
48     function updateTokensApproved () {
49         tokensApproved = _STCnContract.allowance(_multiSendOwner, this);
50     }
51     
52 }