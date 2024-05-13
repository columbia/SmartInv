1 // SPDX-License-Identifier: MIT
2 
3 // Spell
4 
5 // Special thanks to:
6 // @BoringCrypto for his great libraries
7 
8 pragma solidity 0.6.12;
9 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
10 import "@boringcrypto/boring-solidity/contracts/ERC20.sol";
11 import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";
12 
13 /// @title Spell
14 /// @author 0xMerlin
15 /// @dev This contract allows contract calls to any contract (except BentoBox)
16 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
17 contract Spell is ERC20, BoringOwnable {
18     using BoringMath for uint256;
19     // ERC20 'variables'
20     string public constant symbol = "SPELL";
21     string public constant name = "Spell Token";
22     uint8 public constant decimals = 18;
23     uint256 public override totalSupply;
24     uint256 public constant MAX_SUPPLY = 420 * 1e27;
25 
26     function mint(address to, uint256 amount) public onlyOwner {
27         require(to != address(0), "SPELL: no mint to zero address");
28         require(MAX_SUPPLY >= totalSupply.add(amount), "SPELL: Don't go over MAX");
29 
30         totalSupply = totalSupply + amount;
31         balanceOf[to] += amount;
32         emit Transfer(address(0), to, amount);
33     }
34 }
