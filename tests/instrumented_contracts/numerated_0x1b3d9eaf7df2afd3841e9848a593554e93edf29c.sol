1 pragma solidity ^0.4.21;
2 
3 // Project: imigize.io (original)
4 // v13, 2018-06-19
5 // This code is the property of CryptoB2B.io
6 // Copying in whole or in part is prohibited.
7 // Authors: Ivan Fedorov and Dmitry Borodin
8 // Do you want the same TokenSale platform? www.cryptob2b.io
9 
10 contract IRightAndRoles {
11     address[][] public wallets;
12     mapping(address => uint16) public roles;
13 
14     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
15     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
16 
17     function changeWallet(address _wallet, uint8 _role) external;
18     function setManagerPowerful(bool _mode) external;
19     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
20 }
21 
22 contract RightAndRoles is IRightAndRoles {
23     bool managerPowerful = true;
24 
25     function RightAndRoles(address[] _roles) public {
26         uint8 len = uint8(_roles.length);
27         require(len > 0&&len <16);
28         wallets.length = len;
29 
30         for(uint8 i = 0; i < len; i++){
31             wallets[i].push(_roles[i]);
32             roles[_roles[i]] += uint16(2)**i;
33             emit WalletChanged(_roles[i], address(0),i);
34         }
35     }
36 
37     function changeClons(address _clon, uint8 _role, bool _mod) external {
38         require(wallets[_role][0] == msg.sender&&_clon != msg.sender);
39         emit CloneChanged(_clon,_role,_mod);
40         uint16 roleMask = uint16(2)**_role;
41         if(_mod){
42             require(roles[_clon]&roleMask == 0);
43             wallets[_role].push(_clon);
44         }else{
45             address[] storage tmp = wallets[_role];
46             uint8 i = 1;
47             for(i; i < tmp.length; i++){
48                 if(tmp[i] == _clon) break;
49             }
50             require(i > tmp.length);
51             tmp[i] = tmp[tmp.length];
52             delete tmp[tmp.length];
53         }
54         roles[_clon] = _mod?roles[_clon]|roleMask:roles[_clon]&~roleMask;
55     }
56 
57     // Change the address for the specified role.
58     // Available to any wallet owner except the observer.
59     // Available to the manager until the round is initialized.
60     // The Observer's wallet or his own manager can change at any time.
61     // @ Do I have to use the function      no
62     // @ When it is possible to call        depend...
63     // @ When it is launched automatically  -
64     // @ Who can call the function          staff (all 7+ roles)
65     function changeWallet(address _wallet, uint8 _role) external {
66         require(wallets[_role][0] == msg.sender || wallets[0][0] == msg.sender || (wallets[1][0] == msg.sender && managerPowerful));
67         emit WalletChanged(wallets[_role][0],_wallet,_role);
68         uint16 roleMask = uint16(2)**_role;
69         address[] storage tmp = wallets[_role];
70         for(uint8 i = 0; i < tmp.length; i++){
71             roles[tmp[i]] = roles[tmp[i]]&~roleMask;
72         }
73         delete  wallets[_role];
74         tmp.push(_wallet);
75         roles[_wallet] = roles[_wallet]|roleMask;
76     }
77 
78     function setManagerPowerful(bool _mode) external {
79         require(wallets[0][0] == msg.sender);
80         managerPowerful = _mode;
81     }
82 
83     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool) {
84         return roles[_sender]&_roleMask != 0;
85     }
86 
87     function getMainWallets() view external returns(address[]){
88         address[] memory _wallets = new address[](wallets.length);
89         for(uint8 i = 0; i<wallets.length; i++){
90             _wallets[i] = wallets[i][0];
91         }
92         return _wallets;
93     }
94 
95     function getCloneWallets(uint8 _role) view external returns(address[]){
96         return wallets[_role];
97     }
98 }