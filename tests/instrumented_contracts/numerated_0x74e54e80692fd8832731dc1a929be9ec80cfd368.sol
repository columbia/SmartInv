1 // Project: AleHub
2 // v1, 2018-05-24
3 // This code is the property of CryptoB2B.io
4 // Copying in whole or in part is prohibited.
5 // Authors: Ivan Fedorov and Dmitry Borodin
6 // Do you want the same TokenSale platform? www.cryptob2b.io
7 
8 // *.sol in 1 file - https://cryptob2b.io/solidity/alehub/
9 
10 pragma solidity ^0.4.21;
11 
12 contract IRightAndRoles {
13     address[][] public wallets;
14     mapping(address => uint16) public roles;
15 
16     event WalletChanged(address indexed newWallet, address indexed oldWallet, uint8 indexed role);
17     event CloneChanged(address indexed wallet, uint8 indexed role, bool indexed mod);
18 
19     function changeWallet(address _wallet, uint8 _role) external;
20     function setManagerPowerful(bool _mode) external;
21     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool);
22 }
23 
24 contract RightAndRoles is IRightAndRoles {
25     bool managerPowerful = true;
26 
27     function RightAndRoles(address[] _roles) public {
28         uint8 len = uint8(_roles.length);
29         require(len > 0&&len <16);
30         wallets.length = len;
31 
32         for(uint8 i = 0; i < len; i++){
33             wallets[i].push(_roles[i]);
34             roles[_roles[i]] += uint16(2)**i;
35             emit WalletChanged(_roles[i], address(0),i);
36         }
37     }
38 
39     function changeClons(address _clon, uint8 _role, bool _mod) external {
40         require(wallets[_role][0] == msg.sender&&_clon != msg.sender);
41         emit CloneChanged(_clon,_role,_mod);
42         uint16 roleMask = uint16(2)**_role;
43         if(_mod){
44             require(roles[_clon]&roleMask == 0);
45             wallets[_role].push(_clon);
46         }else{
47             address[] storage tmp = wallets[_role];
48             uint8 i = 1;
49             for(i; i < tmp.length; i++){
50                 if(tmp[i] == _clon) break;
51             }
52             require(i > tmp.length);
53             tmp[i] = tmp[tmp.length];
54             delete tmp[tmp.length];
55         }
56         roles[_clon] = _mod?roles[_clon]|roleMask:roles[_clon]&~roleMask;
57     }
58 
59     // Change the address for the specified role.
60     // Available to any wallet owner except the observer.
61     // Available to the manager until the round is initialized.
62     // The Observer's wallet or his own manager can change at any time.
63     // @ Do I have to use the function      no
64     // @ When it is possible to call        depend...
65     // @ When it is launched automatically  -
66     // @ Who can call the function          staff (all 7+ roles)
67     function changeWallet(address _wallet, uint8 _role) external {
68         require(wallets[_role][0] == msg.sender || wallets[0][0] == msg.sender || (wallets[1][0] == msg.sender && managerPowerful /* && _role != 0*/));
69         emit WalletChanged(wallets[_role][0],_wallet,_role);
70         uint16 roleMask = uint16(2)**_role;
71         address[] storage tmp = wallets[_role];
72         for(uint8 i = 0; i < tmp.length; i++){
73             roles[tmp[i]] = roles[tmp[i]]&~roleMask;
74         }
75         delete  wallets[_role];
76         tmp.push(_wallet);
77         roles[_wallet] = roles[_wallet]|roleMask;
78     }
79 
80     function setManagerPowerful(bool _mode) external {
81         require(wallets[0][0] == msg.sender);
82         managerPowerful = _mode;
83     }
84 
85     function onlyRoles(address _sender, uint16 _roleMask) view external returns(bool) {
86         return roles[_sender]&_roleMask != 0;
87     }
88 
89     function getMainWallets() view external returns(address[]){
90         address[] memory _wallets = new address[](wallets.length);
91         for(uint8 i = 0; i<wallets.length; i++){
92             _wallets[i] = wallets[i][0];
93         }
94         return _wallets;
95     }
96 
97     function getCloneWallets(uint8 _role) view external returns(address[]){
98         return wallets[_role];
99     }
100 }