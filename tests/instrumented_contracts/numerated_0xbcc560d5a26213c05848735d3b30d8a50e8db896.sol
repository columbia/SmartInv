1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.14;
3 
4 
5 interface ILightERC721 {
6   function transferFrom(address _from, address _to, uint256 _tokenId) external;
7   function ownerOf(uint256 _tokenId) external view returns (address);
8 }
9 
10 contract AirdropHelper {
11   ILightERC721 public llamascape = ILightERC721(0xE5C7D9A18df4fDc12DB723761A862845612917bA);
12   address public llama = 0xe8d939F1a9CC4e85E09AFf3d60d137a1Bea17b21;
13   address public admin = 0x000000003604223ecc88b0205fc02efBe35F437f;
14 
15   mapping(address => uint[]) public wl;
16 
17   function addToWhitelist(address _addr,  uint _tokenId) internal {
18     wl[_addr].push(_tokenId);
19   }
20 
21   modifier onlyLlama {
22     require(msg.sender == llama || msg.sender == admin);
23     _;
24   }
25 
26   function resetWhitelistForUser(address _addr) public onlyLlama {
27     wl[_addr] = new uint[](0);
28   }
29 
30   function uploadWhitelist(address[] calldata addresses, uint[] calldata tokenIds) public onlyLlama {
31     for (uint i = 0; i < addresses.length; i++) {
32       addToWhitelist(addresses[i], tokenIds[i]);
33     }
34   }
35 
36   function mint() public {
37     uint[] storage ids = wl[msg.sender];
38     for (uint i = 0; i < ids.length; i++) {
39       llamascape.transferFrom(llama, msg.sender, ids[i]);
40     }
41   }
42 
43   function isWhitelisted(address user) public view returns (bool){
44     // If llama doesn't own the token anymore, it has already been transferred
45     return wl[user].length > 0 && llamascape.ownerOf(wl[user][0]) == llama;
46   }
47 }