1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
5 import { LibAsset } from "../Libraries/LibAsset.sol";
6 
7 /// @title ERC20 Proxy
8 /// @author LI.FI (https://li.fi)
9 /// @notice Proxy contract for safely transferring ERC20 tokens for swaps/executions
10 /// @custom:version 1.0.0
11 contract ERC20Proxy is Ownable {
12     /// Storage ///
13     mapping(address => bool) public authorizedCallers;
14 
15     /// Errors ///
16     error UnAuthorized();
17 
18     /// Events ///
19     event AuthorizationChanged(address indexed caller, bool authorized);
20 
21     /// Constructor
22     constructor(address _owner) {
23         transferOwnership(_owner);
24     }
25 
26     /// @notice Sets whether or not a specified caller is authorized to call this contract
27     /// @param caller the caller to change authorization for
28     /// @param authorized specifies whether the caller is authorized (true/false)
29     function setAuthorizedCaller(
30         address caller,
31         bool authorized
32     ) external onlyOwner {
33         authorizedCallers[caller] = authorized;
34         emit AuthorizationChanged(caller, authorized);
35     }
36 
37     /// @notice Transfers tokens from one address to another specified address
38     /// @param tokenAddress the ERC20 contract address of the token to send
39     /// @param from the address to transfer from
40     /// @param to the address to transfer to
41     /// @param amount the amount of tokens to send
42     function transferFrom(
43         address tokenAddress,
44         address from,
45         address to,
46         uint256 amount
47     ) external {
48         if (!authorizedCallers[msg.sender]) revert UnAuthorized();
49 
50         LibAsset.transferFromERC20(tokenAddress, from, to, amount);
51     }
52 }
