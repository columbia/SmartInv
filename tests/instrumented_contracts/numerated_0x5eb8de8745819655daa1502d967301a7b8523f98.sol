1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract PaymentReceiver
27 {
28  address private constant taxman = 0xB13D7Dab5505512924CB8E1bE970B849009d34Da;
29  address private constant store = 0x23859DBF88D714125C65d1B41a8808cADB199D9E;
30  address private constant pkt = 0x2604fa406be957e542beb89e6754fcde6815e83f;
31 
32   modifier onlyTaxman { require(msg.sender == taxman); _; }
33 
34   function withdrawTokens(uint256 value) external onlyTaxman
35   {
36     ERC20 token = ERC20(pkt);
37     token.transfer(store, value);
38   }
39 }