1 pragma solidity ^0.4.15;
2 
3 // File: contracts/minter-service/IICOInfo.sol
4 
5 contract IICOInfo {
6   function estimate(uint256 _wei) public constant returns (uint tokens);
7   function purchasedTokenBalanceOf(address addr) public constant returns (uint256 tokens);
8   function isSaleActive() public constant returns (bool active);
9 }
10 
11 // File: contracts/minter-service/IMintableToken.sol
12 
13 contract IMintableToken {
14     function mint(address _to, uint256 _amount);
15 }
16 
17 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) onlyOwner {
51     if (newOwner != address(0)) {
52       owner = newOwner;
53     }
54   }
55 
56 }
57 
58 // File: contracts/minter-service/ReenterableMinter.sol
59 
60 contract ReenterableMinter is Ownable {
61     event MintSuccess(bytes32 indexed mint_id);
62 
63     function ReenterableMinter(IMintableToken token){
64         m_token = token;
65     }
66 
67     function mint(bytes32 mint_id, address to, uint256 amount) onlyOwner {
68         // Not reverting because there will be no way to distinguish this revert from other transaction failures.
69         if (!m_processed_mint_id[mint_id]) {
70             m_token.mint(to, amount);
71             m_processed_mint_id[mint_id] = true;
72         }
73         MintSuccess(mint_id);
74     }
75 
76     IMintableToken public m_token;
77     mapping(bytes32 => bool) public m_processed_mint_id;
78 }