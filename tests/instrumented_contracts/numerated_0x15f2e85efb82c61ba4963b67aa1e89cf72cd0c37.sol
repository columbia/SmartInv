1 // Congratulations! Its your free airdrop token. More about project at: https://MARK.SPACE
2 //
3 //
4 // An open source platform for creation of 3D- and VR- compatible web-spaces (websites) and objects, powered by Blockchain.
5 // 3DとVR対応のウェブ空間(ウェブサイト)とオブジェクトの作成が可能な ブロックチェーンベースのオープンソースプラットフォーム
6 // 由区块链支持的创造3D/VR兼容网页空间的开源平台
7 // Una plataforma de código abierto para la creación de espacios web (sitios web) y objetos compatibles con 3D y VR, con tecnología de Blockchain.                                                 
8 // 3D와 VR 호환이 가능한 웹 스페이스(웹 사이트)와 사물을 창조해내는 블록체인 기반의 오픈소스 플랫폼
9 // Платформа с открытым исходным кодом для создания 3D / VR - совместимых онлайн-пространств (сайтов) и объектов, на базе технологии Блокчейн.
10 // Una plataforma de código abierto para la creación de espacios web (sitios web) y objetos compatibles con 3D y VR, con tecnología de Blockchain.
11 //
12 //     ▄▄▄▄▄▄▄▄▄                                                                                                  
13 //   ▄▀         ▀▄                                                                                                 
14 //  █   ▄     ▄   █     ▐█▄     ▄█▌     ▄██▄    ▐█▀▀▀▀█▄  █   ▄█▀      ▄█▀▀▀▀█  ▐█▀▀▀▀█▄    ▄██▄     ██▀▀▀▀█  ▐█▀▀▀▀▀
15 // ▐▌  ▀▄▀   ▀▄▀  ▐▌    ▐█▀█  ▄█▀█▌    ▄█  █▄   ▐█    ██  ██▄██        ▀█▄▄▄    ▐█    ██   ▄█  █▄   █▌        ▐█▄▄▄▄
16 // ▐▌   ▐▀▄ ▄▀▌   ▐▌    ▐█  █▄█  █▌   ▄█▄▄▄▄█▄  ▐█▀▀██▀   ██▀ ▐█            ██  ▐█▀▀▀▀▀   ▄█▄▄▄▄█▄  ██        ▐█     
17 //  ▀▄  ▀  ▀  ▀  ▄▀     ▐█   ▀   █▌  ▄█      █▄ ▐█   ▐█▄  █     █▄ ▐█  ▀█▄▄▄█▀  ▐█       ▄█      █▄  ▀█▄▄▄▄█  ▐█▄▄▄▄▄
18 //    ▀▄▄▄▄▄▄▄▄▄▀                                                                                                  
19 
20                                                                                                               
21 pragma solidity 0.4.18;
22 
23 contract Ownable {
24     address public owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     modifier onlyOwner() { require(msg.sender == owner); _; }
29 
30     function Ownable() public {
31         owner = msg.sender;
32     }
33 
34     function transferOwnership(address newOwner) public onlyOwner {
35         require(newOwner != address(0));
36         owner = newOwner;
37         OwnershipTransferred(owner, newOwner);
38     }
39 }
40 
41 contract Withdrawable is Ownable {
42     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
43         require(_to != address(0));
44         require(this.balance >= _value);
45 
46         _to.transfer(_value);
47 
48         return true;
49     }
50 
51     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
52         require(_to != address(0));
53 
54         return _token.transfer(_to, _value);
55     }
56 }
57 
58 contract ERC20 {
59     uint256 public totalSupply;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 
64     function balanceOf(address who) public view returns(uint256);
65     function transfer(address to, uint256 value) public returns(bool);
66     function transferFrom(address from, address to, uint256 value) public returns(bool);
67     function allowance(address owner, address spender) public view returns(uint256);
68     function approve(address spender, uint256 value) public returns(bool);
69 }
70 
71 contract AirDrop is Withdrawable {
72     event TransferEther(address indexed to, uint256 value);
73 
74     function tokenBalanceOf(ERC20 _token) public view returns(uint256) {
75         return _token.balanceOf(this);
76     }
77 
78     function tokenAllowance(ERC20 _token, address spender) public view returns(uint256) {
79         return _token.allowance(this, spender);
80     }
81     
82     function tokenTransfer(ERC20 _token, uint _value, address[] _to) onlyOwner public {
83         require(_token != address(0));
84 
85         for(uint i = 0; i < _to.length; i++) {
86             require(_token.transfer(_to[i], _value));
87         }
88     }
89     
90     function tokenTransferFrom(ERC20 _token, address spender, uint _value, address[] _to) onlyOwner public {
91         require(_token != address(0));
92 
93         for(uint i = 0; i < _to.length; i++) {
94             require(_token.transferFrom(spender, _to[i], _value));
95         }
96     }
97 
98     function etherTransfer(uint _value, address[] _to) onlyOwner payable public {
99         for(uint i = 0; i < _to.length; i++) {
100             _to[i].transfer(_value);
101             TransferEther(_to[i], _value);
102         }
103     }
104 }