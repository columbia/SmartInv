1 pragma solidity ^0.4.21;
2 
3 contract Updater
4 {
5     mapping (address => bool) public owners;
6 
7     struct State {
8         bool exchange;
9         bool payment;
10     }
11     mapping(address => State) public states;
12 
13     event InfoUpdated(bytes4 indexed method, address indexed target, bool indexed res, uint256 ETHUSD, uint256 token, uint256 value);
14     event OwnerChanged(address indexed previousOwner, bool state);
15 
16     modifier onlyOwner() {
17         require(owners[msg.sender]);
18         _;
19     }
20 
21     function Updater() public {
22         owners[msg.sender] = true;
23     }
24 
25     function setOwner(address _newOwner,bool _state) onlyOwner public {
26         emit OwnerChanged(_newOwner, _state);
27         owners[_newOwner] = _state;
28     }
29 
30     function setStates(address[] _addr, uint8[] _exchange, uint8[] _payment) onlyOwner public {
31         for(uint256 i = 0; i < _addr.length; i++){
32             states[_addr[i]].exchange = _exchange[i]>0;
33             states[_addr[i]].payment = _payment[i]>0;
34         }
35     }
36 
37     function update(address[] _addr, uint256[] _ETHUSD, uint256[] _token, uint256[] _value) onlyOwner public {
38         for(uint256 i = 0; i < _addr.length; i++){
39             State storage state = states[_addr[i]];
40             bool res;
41             if(!(state.exchange || state.payment)){
42                 res=_addr[i].call(bytes4(keccak256("updateInfo(uint256,uint256,uint256)")),_ETHUSD[i],_token[i],_value[i]);
43                 emit InfoUpdated(bytes4(keccak256("updateInfo(uint256,uint256,uint256)")),_addr[i],res,_ETHUSD[i],_token[i],_value[i]);
44                 continue;
45             }
46             if(state.exchange){
47                 res=_addr[i].call(bytes4(keccak256("changeExchange(uint256)")),_ETHUSD[i]);
48                 emit InfoUpdated(bytes4(keccak256("changeExchange(uint256)")),_addr[i],res,_ETHUSD[i],0x0,0x0);
49             }
50             if(state.payment){
51                 res=_addr[i].call(bytes4(keccak256("paymentsInOtherCurrency(uint256,uint256)")),_token[i],_value[i]);
52                 emit InfoUpdated(bytes4(keccak256("paymentsInOtherCurrency(uint256,uint256)")),_addr[i],res,0x0,_token[i],_value[i]);
53             }
54         }
55     }
56 }