1 pragma solidity 0.4.11;
2 
3 // © 2016 Ambisafe Inc. No reuse without written permission is allowed.
4 
5 contract CrypviserICO {
6     struct PendingOperation {
7         mapping(address => bool) hasConfirmed;
8         uint yetNeeded;
9     }
10 
11     mapping(bytes32 => PendingOperation) pending;
12     uint public required;
13     mapping(address => bool) public isOwner;
14     address[] public owners;
15 
16     event Confirmation(address indexed owner, bytes32 indexed operation, bool completed);
17 
18     function CrypviserICO(address[] _owners, uint _required) {
19         if (_owners.length == 0 || _required == 0 || _required > _owners.length) {
20             selfdestruct(msg.sender);
21         }
22         required = _required;
23         for (uint i = 0; i < _owners.length; i++) {
24             owners.push(_owners[i]);
25             isOwner[_owners[i]] = true;
26         }
27     }
28 
29     function hasConfirmed(bytes32 _operation, address _owner) constant returns(bool) {
30         return pending[_operation].hasConfirmed[_owner];
31     }
32     
33     function n() constant returns(uint) {
34         return required;
35     }
36     
37     function m() constant returns(uint) {
38         return owners.length;
39     }
40 
41     modifier onlyowner() {
42         if (!isOwner[msg.sender]) {
43             throw;
44         }
45         _;
46     }
47 
48     modifier onlymanyowners(bytes32 _operation) {
49         if (_confirmAndCheck(_operation)) {
50             _;
51         }
52     }
53 
54     function _confirmAndCheck(bytes32 _operation) onlyowner() internal returns(bool) {
55         if (hasConfirmed(_operation, msg.sender)) {
56             throw;
57         }
58 
59         var pendingOperation = pending[_operation];
60         if (pendingOperation.yetNeeded == 0) {
61             pendingOperation.yetNeeded = required;
62         }
63 
64         if (pendingOperation.yetNeeded <= 1) {
65             Confirmation(msg.sender, _operation, true);
66             _removeOperation(_operation);
67             return true;
68         } else {
69             Confirmation(msg.sender, _operation, false);
70             pendingOperation.yetNeeded--;
71             pendingOperation.hasConfirmed[msg.sender] = true;
72         }
73 
74         return false;
75     }
76 
77     function _removeOperation(bytes32 _operation) internal {
78         var pendingOperation = pending[_operation];
79         for (uint i = 0; i < owners.length; i++) {
80             if (pendingOperation.hasConfirmed[owners[i]]) {
81                 pendingOperation.hasConfirmed[owners[i]] = false;
82             }
83         }
84         delete pending[_operation];
85     }
86 
87     function send(address _to, uint _value) onlymanyowners(sha3(msg.data)) returns(bool) {
88         return _to.send(_value);
89     }
90     
91     event Received(address indexed addr, uint value);
92     function () payable {
93         if (msg.value > 0) {
94             Received(msg.sender, msg.value);
95         }
96     }
97 }