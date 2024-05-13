1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 interface IBridgeHook {
5     /**
6      * @notice Handles an incoming bridge transfer with some tokens and extra
7      * data. Takes any necessary actions for the hook's purposes.
8      *
9      * This function is intended to allow arbitrary post-bridge actions with
10      * tokens, at a user's discretion. E.g. recollateralize a CDP, exchange for
11      * other tokens, emit an event, etc.
12      *
13      * @dev This hook is called AFTER tokens have been transferred to the hook
14      * contract. If this hook errors, the bridge WILL NOT revert, and the hook
15      * contract will own those tokens. Hook contracts MUST have a recovery plan
16      * in place for these situations.
17      *
18      * @param _origin The domain of the chain from which the transfer originated
19      * @param _sender The identifier of the caller which sent the tokens over the bridge
20      * @param _tokenDomain The canonical deployment domain of the token
21      * @param _tokenAddress The identifier for the token on its canonical domain
22      * @param _localToken The local address of the token (its canonical
23      *                    address if it is local to this domain, otherwise its
24      *                    the address of its local representation).
25      * @param _amount The amount of token received over the bridge
26      * @param _extraData Extra user-specified data passed in to the origin chain
27      */
28     function onReceive(
29         uint32 _origin,
30         bytes32 _sender,
31         uint32 _tokenDomain,
32         bytes32 _tokenAddress,
33         address _localToken,
34         uint256 _amount,
35         bytes memory _extraData
36     ) external;
37 }
