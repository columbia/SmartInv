1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
5 import "@boringcrypto/boring-solidity/contracts/ERC20.sol";
6 import "@sushiswap/bentobox-sdk/contracts/IBentoBoxV1.sol";
7 import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";
8 
9 /// @title Cauldron
10 /// @dev This contract allows contract calls to any contract (except BentoBox)
11 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
12 contract NXUSD is ERC20, BoringOwnable {
13     using BoringMath for uint256;
14     // ERC20 'variables'
15     string public constant symbol = "NXUSD";
16     string public constant name = "NXUSD";
17     uint8 public constant decimals = 18;
18     uint256 public override totalSupply;
19 
20     struct Minting {
21         uint128 time;
22         uint128 amount;
23     }
24 
25     Minting public lastMint;
26     uint256 private constant MINTING_PERIOD = 24 hours;
27     uint256 private constant MINTING_INCREASE = 15000;
28     uint256 private constant MINTING_PRECISION = 1e5;
29 
30     function mint(address to, uint256 amount) public onlyOwner {
31         require(to != address(0), "NXUSD: no mint to zero address");
32 
33         // Limits the amount minted per period to a convergence function, with the period duration restarting on every mint
34         uint256 totalMintedAmount = uint256(lastMint.time < block.timestamp - MINTING_PERIOD ? 0 : lastMint.amount).add(amount);
35         require(totalSupply == 0 || totalSupply.mul(MINTING_INCREASE) / MINTING_PRECISION >= totalMintedAmount);
36 
37         lastMint.time = block.timestamp.to128();
38         lastMint.amount = totalMintedAmount.to128();
39 
40         totalSupply = totalSupply + amount;
41         balanceOf[to] += amount;
42         emit Transfer(address(0), to, amount);
43     }
44 
45     function mintToBentoBox(address clone, uint256 amount, IBentoBoxV1 bentoBox) public onlyOwner {
46         mint(address(bentoBox), amount);
47         bentoBox.deposit(IERC20(address(this)), address(bentoBox), clone, amount, 0);
48     }
49 
50     function burn(uint256 amount) public {
51         require(amount <= balanceOf[msg.sender], "NXUSD: not enough");
52 
53         balanceOf[msg.sender] -= amount;
54         totalSupply -= amount;
55         emit Transfer(msg.sender, address(0), amount);
56     }
57 }
