pragma solidity ^0.5.0;


contract IRelayRecipient {

    /**
     * return the relayHub of this contract.
     */
    function getHubAddr() public view returns (address);

    /**
     * return the contract's balance on the RelayHub.
     * can be used to determine if the contract can pay for incoming calls,
     * before making any.
     */
    function getRecipientBalance() public view returns (uint256);

    /*
     * Called by Relay (and RelayHub), to validate if this recipient accepts this call.
     * Note: Accepting this call means paying for the tx whether the relayed call reverted or not.
     *
     *  @return "0" if the the contract is willing to accept the charges from this sender, for this function call.
     *      any other value is a failure. actual value is for diagnostics only.
     *      ** Note: values below 10 are reserved by canRelay

     *  @param relay the relay that attempts to relay this function call.
     *          the contract may restrict some encoded functions to specific known relays.
     *  @param from the sender (signer) of this function call.
     *  @param encodedFunction the encoded function call (without any ethereum signature).
     *          the contract may check the method-id for valid methods
     *  @param gasPrice - the gas price for this transaction
     *  @param transactionFee - the relay compensation (in %) for this transaction
     *  @param signature - sender's signature over all parameters except approvalData
     *  @param approvalData - extra dapp-specific data (e.g. signature from trusted party)
     */
     function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    )
    external
    view
    returns (uint256, bytes memory);

    /*
     * modifier to be used by recipients as access control protection for preRelayedCall & postRelayedCall
     */
    modifier relayHubOnly() {
        require(msg.sender == getHubAddr(),"Function can only be called by RelayHub");
        _;
    }

    /** this method is called before the actual relayed function call.
     * It may be used to charge the caller before (in conjuction with refunding him later in postRelayedCall for example).
     * the method is given all parameters of acceptRelayedCall and actual used gas.
     *
     *
     *** NOTICE: if this method modifies the contract's state, it must be protected with access control i.e. require msg.sender == getHubAddr()
     *
     *
     * Revert in this functions causes a revert of the client's relayed call but not in the entire transaction
     * (that is, the relay will still get compensated)
     */
    function preRelayedCall(bytes calldata context) external returns (bytes32);

    /** this method is called after the actual relayed function call.
     * It may be used to record the transaction (e.g. charge the caller by some contract logic) for this call.
     * the method is given all parameters of acceptRelayedCall, and also the success/failure status and actual used gas.
     *
     *
     *** NOTICE: if this method modifies the contract's state, it must be protected with access control i.e. require msg.sender == getHubAddr()
     *
     *
     * @param success - true if the relayed call succeeded, false if it reverted
     * @param actualCharge - estimation of how much the recipient will be charged. This information may be used to perform local booking and
     *   charge the sender for this call (e.g. in tokens).
     * @param preRetVal - preRelayedCall() return value passed back to the recipient
     *
     * Revert in this functions causes a revert of the client's relayed call but not in the entire transaction
     * (that is, the relay will still get compensated)
     */
    function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) external;

}

contract IRelayHub {
    // Relay management

    // Add stake to a relay and sets its unstakeDelay.
    // If the relay does not exist, it is created, and the caller
    // of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
    // cannot be its own owner.
    // All Ether in this function call will be added to the relay's stake.
    // Its unstake delay will be assigned to unstakeDelay, but the new value must be greater or equal to the current one.
    // Emits a Staked event.
    function stake(address relayaddr, uint256 unstakeDelay) external payable;

    // Emited when a relay's stake or unstakeDelay are increased
    event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);

    // Registers the caller as a relay.
    // The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
    // Emits a RelayAdded event.
    // This function can be called multiple times, emitting new RelayAdded events. Note that the received transactionFee
    // is not enforced by relayCall.
    function registerRelay(uint256 transactionFee, string memory url) public;

    // Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out RelayRemoved
    // events) lets a client discover the list of available relays.
    event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);

    // Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed. Can only be called by
    // the owner of the relay. After the relay's unstakeDelay has elapsed, unstake will be callable.
    // Emits a RelayRemoved event.
    function removeRelayByOwner(address relay) public;

    // Emitted when a relay is removed (deregistered). unstakeTime is the time when unstake will be callable.
    event RelayRemoved(address indexed relay, uint256 unstakeTime);

    // Deletes the relay from the system, and gives back its stake to the owner. Can only be called by the relay owner,
    // after unstakeDelay has elapsed since removeRelayByOwner was called.
    // Emits an Unstaked event.
    function unstake(address relay) public;

    // Emitted when a relay is unstaked for, including the returned stake.
    event Unstaked(address indexed relay, uint256 stake);

    // States a relay can be in
    enum RelayState {
        Unknown, // The relay is unknown to the system: it has never been staked for
        Staked, // The relay has been staked for, but it is not yet active
        Registered, // The relay has registered itself, and is active (can relay calls)
        Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
    }

    // Returns a relay's status. Note that relays can be deleted when unstaked or penalized.
    function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);

    // Balance management

    // Deposits ether for a contract, so that it can receive (and pay for) relayed transactions. Unused balance can only
    // be withdrawn by the contract itself, by callingn withdraw.
    // Emits a Deposited event.
    function depositFor(address target) public payable;

    // Emitted when depositFor is called, including the amount and account that was funded.
    event Deposited(address indexed recipient, address indexed from, uint256 amount);

    // Returns an account's deposits. These can be either a contnract's funds, or a relay owner's revenue.
    function balanceOf(address target) external view returns (uint256);

    // Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
    // contracts can also use it to reduce their funding.
    // Emits a Withdrawn event.
    function withdraw(uint256 amount, address payable dest) public;

    // Emitted when an account withdraws funds from RelayHub.
    event Withdrawn(address indexed account, address indexed dest, uint256 amount);

    // Relaying

    // Check if the RelayHub will accept a relayed operation. Multiple things must be true for this to happen:
    //  - all arguments must be signed for by the sender (from)
    //  - the sender's nonce must be the current one
    //  - the recipient must accept this transaction (via acceptRelayedCall)
    // Returns a PreconditionCheck value (OK when the transaction can be relayed), or a recipient-specific error code if
    // it returns one in acceptRelayedCall.
    function canRelay(
        address relay,
        address from,
        address to,
        bytes memory encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes memory signature,
        bytes memory approvalData
    ) public view returns (uint256 status, bytes memory recipientContext);

    // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
    enum PreconditionCheck {
        OK,                         // All checks passed, the call can be relayed
        WrongSignature,             // The transaction to relay is not signed by requested sender
        WrongNonce,                 // The provided nonce has already been used by the sender
        AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
        InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
    }

    // Relays a transaction. For this to suceed, multiple conditions must be met:
    //  - canRelay must return PreconditionCheck.OK
    //  - the sender must be a registered relay
    //  - the transaction's gas price must be larger or equal to the one that was requested by the sender
    //  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
    // recipient) use all gas available to them
    //  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
    // spent)
    //
    // If all conditions are met, the call will be relayed and the recipient charged. preRelayedCall, the encoded
    // function and postRelayedCall will be called in order.
    //
    // Arguments:
    //  - from: the client originating the request
    //  - recipient: the target IRelayRecipient contract
    //  - encodedFunction: the function call to relay, including data
    //  - transactionFee: fee (%) the relay takes over actual gas cost
    //  - gasPrice: gas price the client is willing to pay
    //  - gasLimit: gas to forward when calling the encoded function
    //  - nonce: client's nonce
    //  - signature: client's signature over all previous params, plus the relay and RelayHub addresses
    //  - approvalData: dapp-specific data forwared to acceptRelayedCall. This value is *not* verified by the Hub, but
    //    it still can be used for e.g. a signature.
    //
    // Emits a TransactionRelayed event.
    function relayCall(
        address from,
        address to,
        bytes memory encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes memory signature,
        bytes memory approvalData
    ) public;

    // Emitted when an attempt to relay a call failed. This can happen due to incorrect relayCall arguments, or the
    // recipient not accepting the relayed call. The actual relayed call was not executed, and the recipient not charged.
    // The reason field contains an error code: values 1-10 correspond to PreconditionCheck entries, and values over 10
    // are custom recipient error codes returned from acceptRelayedCall.
    event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);

    // Emitted when a transaction is relayed. Note that the actual encoded function might be reverted: this will be
    // indicated in the status field.
    // Useful when monitoring a relay's operation and relayed calls to a contract.
    // Charge is the ether value deducted from the recipient's balance, paid to the relay's owner.
    event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);

    // Reason error codes for the TransactionRelayed event
    enum RelayCallStatus {
        OK,                      // The transaction was successfully relayed and execution successful - never included in the event
        RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
        PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
        PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
        RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
    }

    // Returns how much gas should be forwarded to a call to relayCall, in order to relay a transaction that will spend
    // up to relayedCallStipend gas.
    function requiredGas(uint256 relayedCallStipend) public view returns (uint256);

    // Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
    function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256);

    // Relay penalization. Any account can penalize relays, removing them from the system immediately, and rewarding the
    // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
    // still loses half of its stake.

    // Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
    // different data (gas price, gas limit, etc. may be different). The (unsigned) transaction data and signature for
    // both transactions must be provided.
    function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public;

    // Penalize a relay that sent a transaction that didn't target RelayHub's registerRelay or relayCall.
    function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public;

    event Penalized(address indexed relay, address sender, uint256 amount);

    function getNonce(address from) view external returns (uint256);
}

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/
library LibBytes {

    using LibBytes for bytes;

    /// @dev Gets the memory address for a byte array.
    /// @param input Byte array to lookup.
    /// @return memoryAddress Memory address of byte array. This
    ///         points to the header of the byte array which contains
    ///         the length.
    function rawAddress(bytes memory input)
        internal
        pure
        returns (uint256 memoryAddress)
    {
        assembly {
            memoryAddress := input
        }
        return memoryAddress;
    }
    
    /// @dev Gets the memory address for the contents of a byte array.
    /// @param input Byte array to lookup.
    /// @return memoryAddress Memory address of the contents of the byte array.
    function contentAddress(bytes memory input)
        internal
        pure
        returns (uint256 memoryAddress)
    {
        assembly {
            memoryAddress := add(input, 32)
        }
        return memoryAddress;
    }

    /// @dev Copies `length` bytes from memory location `source` to `dest`.
    /// @param dest memory address to copy bytes to.
    /// @param source memory address to copy bytes from.
    /// @param length number of bytes to copy.
    function memCopy(
        uint256 dest,
        uint256 source,
        uint256 length
    )
        internal
        pure
    {
        if (length < 32) {
            // Handle a partial word by reading destination and masking
            // off the bits we are interested in.
            // This correctly handles overlap, zero lengths and source == dest
            assembly {
                let mask := sub(exp(256, sub(32, length)), 1)
                let s := and(mload(source), not(mask))
                let d := and(mload(dest), mask)
                mstore(dest, or(s, d))
            }
        } else {
            // Skip the O(length) loop when source == dest.
            if (source == dest) {
                return;
            }

            // For large copies we copy whole words at a time. The final
            // word is aligned to the end of the range (instead of after the
            // previous) to handle partial words. So a copy will look like this:
            //
            //  ####
            //      ####
            //          ####
            //            ####
            //
            // We handle overlap in the source and destination range by
            // changing the copying direction. This prevents us from
            // overwriting parts of source that we still need to copy.
            //
            // This correctly handles source == dest
            //
            if (source > dest) {
                assembly {
                    // We subtract 32 from `sEnd` and `dEnd` because it
                    // is easier to compare with in the loop, and these
                    // are also the addresses we need for copying the
                    // last bytes.
                    length := sub(length, 32)
                    let sEnd := add(source, length)
                    let dEnd := add(dest, length)

                    // Remember the last 32 bytes of source
                    // This needs to be done here and not after the loop
                    // because we may have overwritten the last bytes in
                    // source already due to overlap.
                    let last := mload(sEnd)

                    // Copy whole words front to back
                    // Note: the first check is always true,
                    // this could have been a do-while loop.
                    // solhint-disable-next-line no-empty-blocks
                    for {} lt(source, sEnd) {} {
                        mstore(dest, mload(source))
                        source := add(source, 32)
                        dest := add(dest, 32)
                    }
                    
                    // Write the last 32 bytes
                    mstore(dEnd, last)
                }
            } else {
                assembly {
                    // We subtract 32 from `sEnd` and `dEnd` because those
                    // are the starting points when copying a word at the end.
                    length := sub(length, 32)
                    let sEnd := add(source, length)
                    let dEnd := add(dest, length)

                    // Remember the first 32 bytes of source
                    // This needs to be done here and not after the loop
                    // because we may have overwritten the first bytes in
                    // source already due to overlap.
                    let first := mload(source)

                    // Copy whole words back to front
                    // We use a signed comparisson here to allow dEnd to become
                    // negative (happens when source and dest < 32). Valid
                    // addresses in local memory will never be larger than
                    // 2**255, so they can be safely re-interpreted as signed.
                    // Note: the first check is always true,
                    // this could have been a do-while loop.
                    // solhint-disable-next-line no-empty-blocks
                    for {} slt(dest, dEnd) {} {
                        mstore(dEnd, mload(sEnd))
                        sEnd := sub(sEnd, 32)
                        dEnd := sub(dEnd, 32)
                    }
                    
                    // Write the first 32 bytes
                    mstore(dest, first)
                }
            }
        }
    }

    /// @dev Returns a slices from a byte array.
    /// @param b The byte array to take a slice from.
    /// @param from The starting index for the slice (inclusive).
    /// @param to The final index for the slice (exclusive).
    /// @return result The slice containing bytes at indices [from, to)
    function slice(
        bytes memory b,
        uint256 from,
        uint256 to
    )
        internal
        pure
        returns (bytes memory result)
    {
        require(
            from <= to,
            "FROM_LESS_THAN_TO_REQUIRED"
        );
        require(
            to <= b.length,
            "TO_LESS_THAN_LENGTH_REQUIRED"
        );
        
        // Create a new bytes structure and copy contents
        result = new bytes(to - from);
        memCopy(
            result.contentAddress(),
            b.contentAddress() + from,
            result.length
        );
        return result;
    }
    
    /// @dev Returns a slice from a byte array without preserving the input.
    /// @param b The byte array to take a slice from. Will be destroyed in the process.
    /// @param from The starting index for the slice (inclusive).
    /// @param to The final index for the slice (exclusive).
    /// @return result The slice containing bytes at indices [from, to)
    /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
    function sliceDestructive(
        bytes memory b,
        uint256 from,
        uint256 to
    )
        internal
        pure
        returns (bytes memory result)
    {
        require(
            from <= to,
            "FROM_LESS_THAN_TO_REQUIRED"
        );
        require(
            to <= b.length,
            "TO_LESS_THAN_LENGTH_REQUIRED"
        );
        
        // Create a new bytes structure around [from, to) in-place.
        assembly {
            result := add(b, from)
            mstore(result, sub(to, from))
        }
        return result;
    }

    /// @dev Pops the last byte off of a byte array by modifying its length.
    /// @param b Byte array that will be modified.
    /// @return The byte that was popped off.
    function popLastByte(bytes memory b)
        internal
        pure
        returns (bytes1 result)
    {
        require(
            b.length > 0,
            "GREATER_THAN_ZERO_LENGTH_REQUIRED"
        );

        // Store last byte.
        result = b[b.length - 1];

        assembly {
            // Decrement length of byte array.
            let newLen := sub(mload(b), 1)
            mstore(b, newLen)
        }
        return result;
    }

    /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
    /// @param b Byte array that will be modified.
    /// @return The 20 byte address that was popped off.
    function popLast20Bytes(bytes memory b)
        internal
        pure
        returns (address result)
    {
        require(
            b.length >= 20,
            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
        );

        // Store last 20 bytes.
        result = readAddress(b, b.length - 20);

        assembly {
            // Subtract 20 from byte array length.
            let newLen := sub(mload(b), 20)
            mstore(b, newLen)
        }
        return result;
    }

    /// @dev Tests equality of two byte arrays.
    /// @param lhs First byte array to compare.
    /// @param rhs Second byte array to compare.
    /// @return True if arrays are the same. False otherwise.
    function equals(
        bytes memory lhs,
        bytes memory rhs
    )
        internal
        pure
        returns (bool equal)
    {
        // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
        // We early exit on unequal lengths, but keccak would also correctly
        // handle this.
        return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
    }

    /// @dev Reads an address from a position in a byte array.
    /// @param b Byte array containing an address.
    /// @param index Index in byte array of address.
    /// @return address from byte array.
    function readAddress(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (address result)
    {
        require(
            b.length >= index + 20,  // 20 is length of address
            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
        );

        // Add offset to index:
        // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
        // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
        index += 20;

        // Read address from array memory
        assembly {
            // 1. Add index to address of bytes array
            // 2. Load 32-byte word from memory
            // 3. Apply 20-byte mask to obtain address
            result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
        return result;
    }

    /// @dev Writes an address into a specific position in a byte array.
    /// @param b Byte array to insert address into.
    /// @param index Index in byte array of address.
    /// @param input Address to put into byte array.
    function writeAddress(
        bytes memory b,
        uint256 index,
        address input
    )
        internal
        pure
    {
        require(
            b.length >= index + 20,  // 20 is length of address
            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
        );

        // Add offset to index:
        // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
        // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
        index += 20;

        // Store address into array memory
        assembly {
            // The address occupies 20 bytes and mstore stores 32 bytes.
            // First fetch the 32-byte word where we'll be storing the address, then
            // apply a mask so we have only the bytes in the word that the address will not occupy.
            // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.

            // 1. Add index to address of bytes array
            // 2. Load 32-byte word from memory
            // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
            let neighbors := and(
                mload(add(b, index)),
                0xffffffffffffffffffffffff0000000000000000000000000000000000000000
            )
            
            // Make sure input address is clean.
            // (Solidity does not guarantee this)
            input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)

            // Store the neighbors and address into memory
            mstore(add(b, index), xor(input, neighbors))
        }
    }

    /// @dev Reads a bytes32 value from a position in a byte array.
    /// @param b Byte array containing a bytes32 value.
    /// @param index Index in byte array of bytes32 value.
    /// @return bytes32 value from byte array.
    function readBytes32(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (bytes32 result)
    {
        require(
            b.length >= index + 32,
            "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
        );

        // Arrays are prefixed by a 256 bit length parameter
        index += 32;

        // Read the bytes32 from array memory
        assembly {
            result := mload(add(b, index))
        }
        return result;
    }

    /// @dev Writes a bytes32 into a specific position in a byte array.
    /// @param b Byte array to insert <input> into.
    /// @param index Index in byte array of <input>.
    /// @param input bytes32 to put into byte array.
    function writeBytes32(
        bytes memory b,
        uint256 index,
        bytes32 input
    )
        internal
        pure
    {
        require(
            b.length >= index + 32,
            "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
        );

        // Arrays are prefixed by a 256 bit length parameter
        index += 32;

        // Read the bytes32 from array memory
        assembly {
            mstore(add(b, index), input)
        }
    }

    /// @dev Reads a uint256 value from a position in a byte array.
    /// @param b Byte array containing a uint256 value.
    /// @param index Index in byte array of uint256 value.
    /// @return uint256 value from byte array.
    function readUint256(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (uint256 result)
    {
        result = uint256(readBytes32(b, index));
        return result;
    }

    /// @dev Writes a uint256 into a specific position in a byte array.
    /// @param b Byte array to insert <input> into.
    /// @param index Index in byte array of <input>.
    /// @param input uint256 to put into byte array.
    function writeUint256(
        bytes memory b,
        uint256 index,
        uint256 input
    )
        internal
        pure
    {
        writeBytes32(b, index, bytes32(input));
    }

    /// @dev Reads an unpadded bytes4 value from a position in a byte array.
    /// @param b Byte array containing a bytes4 value.
    /// @param index Index in byte array of bytes4 value.
    /// @return bytes4 value from byte array.
    function readBytes4(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (bytes4 result)
    {
        require(
            b.length >= index + 4,
            "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
        );

        // Arrays are prefixed by a 32 byte length field
        index += 32;

        // Read the bytes4 from array memory
        assembly {
            result := mload(add(b, index))
            // Solidity does not require us to clean the trailing bytes.
            // We do it anyway
            result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
        }
        return result;
    }

    /// @dev Reads nested bytes from a specific position.
    /// @dev NOTE: the returned value overlaps with the input value.
    ///            Both should be treated as immutable.
    /// @param b Byte array containing nested bytes.
    /// @param index Index of nested bytes.
    /// @return result Nested bytes.
    function readBytesWithLength(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (bytes memory result)
    {
        // Read length of nested bytes
        uint256 nestedBytesLength = readUint256(b, index);
        index += 32;

        // Assert length of <b> is valid, given
        // length of nested bytes
        require(
            b.length >= index + nestedBytesLength,
            "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
        );
        
        // Return a pointer to the byte array as it exists inside `b`
        assembly {
            result := add(b, index)
        }
        return result;
    }

    /// @dev Inserts bytes at a specific position in a byte array.
    /// @param b Byte array to insert <input> into.
    /// @param index Index in byte array of <input>.
    /// @param input bytes to insert.
    function writeBytesWithLength(
        bytes memory b,
        uint256 index,
        bytes memory input
    )
        internal
        pure
    {
        // Assert length of <b> is valid, given
        // length of input
        require(
            b.length >= index + 32 + input.length,  // 32 bytes to store length
            "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
        );

        // Copy <input> into <b>
        memCopy(
            b.contentAddress() + index,
            input.rawAddress(), // includes length of <input>
            input.length + 32   // +32 bytes to store <input> length
        );
    }

    /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
    /// @param dest Byte array that will be overwritten with source bytes.
    /// @param source Byte array to copy onto dest bytes.
    function deepCopyBytes(
        bytes memory dest,
        bytes memory source
    )
        internal
        pure
    {
        uint256 sourceLen = source.length;
        // Dest length must be >= source length, or some bytes would not be copied.
        require(
            dest.length >= sourceLen,
            "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
        );
        memCopy(
            dest.contentAddress(),
            source.contentAddress(),
            sourceLen
        );
    }
}

// Contract that implements the relay recipient protocol.  Inherited by Gatekeeper, or any other relay recipient.
//
// The recipient contract is responsible to:
// * pass a trusted IRelayHub singleton to the constructor.
// * Implement acceptRelayedCall, which acts as a whitelist/blacklist of senders.  It is advised that the recipient's owner will be able to update that list to remove abusers.
// * In every function that cares about the sender, use "address sender = getSender()" instead of msg.sender.  It'll return msg.sender for non-relayed transactions, or the real sender in case of relayed transactions.
contract RelayRecipient is IRelayRecipient {

    IRelayHub private relayHub; // The IRelayHub singleton which is allowed to call us

    function getHubAddr() public view returns (address) {
        return address(relayHub);
    }

    /**
     * Initialize the RelayHub of this contract.
     * Must be called at least once (e.g. from the constructor), so that the contract can accept relayed calls.
     * For ownable contracts, there should be a method to update the RelayHub, in case a new hub is deployed (since
     * the RelayHub itself is not upgradeable)
     * Otherwise, the contract might be locked on a dead hub, with no relays.
     */
    function setRelayHub(IRelayHub _rhub) internal {
        relayHub = _rhub;
    }

    function getRelayHub() internal view returns (IRelayHub) {
        return relayHub;
    }

    /**
     * return the balance of this contract.
     * Note that this method will revert on configuration error (invalid relay address)
     */
    function getRecipientBalance() public view returns (uint) {
        return getRelayHub().balanceOf(address(this));
    }

    function getSenderFromData(address origSender, bytes memory msgData) public view returns (address) {
        address sender = origSender;
        if (origSender == getHubAddr()) {
            // At this point we know that the sender is a trusted IRelayHub, so we trust that the last bytes of msg.data are the verified sender address.
            // extract sender address from the end of msg.data
            sender = LibBytes.readAddress(msgData, msgData.length - 20);
        }
        return sender;
    }

    /**
     * return the sender of this call.
     * if the call came through the valid RelayHub, return the original sender.
     * otherwise, return `msg.sender`
     * should be used in the contract anywhere instead of msg.sender
     */
    function getSender() public view returns (address) {
        return getSenderFromData(msg.sender, msg.data);
    }

    function getMessageData() public view returns (bytes memory) {
        bytes memory origMsgData = msg.data;
        if (msg.sender == getHubAddr()) {
            // At this point we know that the sender is a trusted IRelayHub, so we trust that the last bytes of msg.data are the verified sender address.
            // extract original message data from the start of msg.data
            origMsgData = new bytes(msg.data.length - 20);
            for (uint256 i = 0; i < origMsgData.length; i++)
            {
                origMsgData[i] = msg.data[i];
            }
        }
        return origMsgData;
    }
}

//SPDX-License-Identifier: MIT License
// import "./RelayRecipient.sol";
// imports needed for artifact generation:
// import "@openeth/gsn/contracts/RelayHub.sol";
// import "./RelayHub.sol";
// import "./IRelayHub.sol";
contract Etheradz is RelayRecipient {
        using SafeMath for *;

        address public owner;
        address public masterAccount;
        uint256 private houseFee = 4;
        uint256 private poolTime = 24 hours;
        uint256 private dailyWinPool = 5;
        uint256 private whalepoolPercentage = 25;
        uint256 private incomeTimes = 30;
        uint256 private incomeDivide = 10;
        uint256 public total_withdraw;
        uint256 public roundID;
        uint256 public currUserID;
        uint256[4] private awardPercentage;

        struct Leaderboard {
            uint256 amt;
            address addr;
        }

        Leaderboard[4] public topSponsors;

        Leaderboard[4] public lastTopSponsors;
        uint256[4] public lastTopSponsorsWinningAmount;

        address[] public etherwhales;


        mapping (uint => uint) public CYCLE_LIMIT;
        mapping (address => bool) public isEtherWhale;
        mapping (uint => address) public userList;
        mapping (uint256 => DataStructs.DailyRound) public round;
        mapping (address => DataStructs.User) public player;
        mapping (address => uint256) public playerTotEarnings;
        mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_;

        /****************************  EVENTS   *****************************************/

        event registerUserEvent(address indexed _playerAddress, address indexed _referrer);
        event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
        event premiumInvestmentEvent(address indexed _playerAddress, uint256 indexed _amount, uint256 _investedAmount);
        event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 _type);
        event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
        event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
        event etherWhaleAwardEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
        event premiumReferralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);


        constructor (
          address _owner,
          address _masterAccount,
          IRelayHub _gsnRelayHub
        )
        public {
             owner = _owner;
             masterAccount = _masterAccount;
             setRelayHub(_gsnRelayHub);
             roundID = 1;
             round[1].startTime = now;
             round[1].endTime = now + poolTime;
             awardPercentage[0] = 40;
             awardPercentage[1] = 30;
             awardPercentage[2] = 20;
             awardPercentage[3] = 10;
             currUserID = 0;

             CYCLE_LIMIT[1]=10 ether;
             CYCLE_LIMIT[2]=25 ether;
             CYCLE_LIMIT[3]=100 ether;
             CYCLE_LIMIT[4]=250 ether;

             currUserID++;
             player[masterAccount].id = currUserID;
             userList[currUserID] = masterAccount;

        }

        function changeHub(IRelayHub _hubAddr)
        public
        onlyOwner {
            setRelayHub(_hubAddr);
        }

        function acceptRelayedCall(
            address relay,
            address from,
            bytes calldata encodedFunction,
            uint256 transactionFee,
            uint256 gasPrice,
            uint256 gasLimit,
            uint256 nonce,
            bytes calldata approvalData,
            uint256 maxPossibleCharge
        )
        external
        view
        returns (uint256, bytes memory) {
          if ( isUser(from) ) return (0, '');

          return (10, '');
        }

        //nothing to be done post-call. still, we must implement this method.
        function preRelayedCall(bytes calldata context) external returns (bytes32){
    		return '';
        }

        function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) external {
        }

        function isUser(address _addr)
        public view returns (bool) {
            return player[_addr].id > 0;
        }

        /****************************  MODIFIERS    *****************************************/


        /**
         * @dev sets boundaries for incoming tx
         */
        modifier isMinimumAmount(uint256 _eth) {
            require(_eth >= 100000000000000000, "Minimum contribution amount is 0.1 ETH");
            _;
        }

        /**
         * @dev sets permissible values for incoming tx
         */
        modifier isallowedValue(uint256 _eth) {
            require(_eth % 100000000000000000 == 0, "multiples of 0.1 ETH please");
            _;
        }

        /**
         * @dev allows only the user to run the function
         */
        modifier onlyOwner() {
            require(getSender() == owner, "only Owner");
            _;
        }

        modifier requireUser() { require(isUser(getSender())); _; }


        /****************************  MAIN LOGIC    *****************************************/

        //function to maintain the business logic
        function registerUser(uint256 _referrerID)
        public
        isMinimumAmount(msg.value)
        isallowedValue(msg.value)
        payable {

            require(_referrerID > 0 && _referrerID <= currUserID, "Incorrect Referrer ID");
            address _referrer = userList[_referrerID];

            uint256 amount = msg.value;
            if (player[getSender()].id <= 0) { //if player is a new joinee
            require(amount <= CYCLE_LIMIT[1], "Can't send more than the limit");

                currUserID++;
                player[getSender()].id = currUserID;
                player[getSender()].depositTime = now;
                player[getSender()].currInvestment = amount;
                player[getSender()].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
                player[getSender()].totalInvestment = amount;
                player[getSender()].referrer = _referrer;
                player[getSender()].cycle = 1;
                userList[currUserID] = getSender();

                player[_referrer].referralCount = player[_referrer].referralCount.add(1);

                plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
                addSponsorToPool(_referrer);
                directsReferralBonus(getSender(), amount);


                  emit registerUserEvent(getSender(), _referrer);
            }
                //if the user is old
            else {

                player[getSender()].cycle = player[getSender()].cycle.add(1);

                require(player[getSender()].incomeLimitLeft == 0, "limit is still remaining");

                require(amount >= (player[getSender()].currInvestment.mul(2) >= 250 ether ? 250 ether : player[getSender()].currInvestment.mul(2)));
                require(amount <= CYCLE_LIMIT[player[getSender()].cycle > 4 ? 4 : player[getSender()].cycle], "Please send correct amount");

                _referrer = player[getSender()].referrer;

                if(amount == 250 ether) {
                    if(isEtherWhale[getSender()] == false){
                        isEtherWhale[getSender()] == true;
                        etherwhales.push(getSender());
                    }
                    player[getSender()].incomeLimitLeft = amount.mul(20).div(incomeDivide);
                }
                else {
                    player[getSender()].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
                }

                player[getSender()].depositTime = now;
                player[getSender()].dailyIncome = 0;
                player[getSender()].currInvestment = amount;
                player[getSender()].totalInvestment = player[getSender()].totalInvestment.add(amount);

                plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
                addSponsorToPool(_referrer);
                directsReferralBonus(getSender(), amount);

            }

                round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
                round[roundID].whalepool = round[roundID].whalepool.add(amount.mul(whalepoolPercentage).div(incomeDivide).div(100));

                address payable ownerAddr = address(uint160(owner));
                ownerAddr.transfer(amount.mul(houseFee).div(100));

                if (now > round[roundID].endTime && round[roundID].ended == false) {
                    startNextRound();
                }

                emit investmentEvent (getSender(), amount);
        }


        function directsReferralBonus(address _playerAddress, uint256 amount)
        private
        {
            address _nextReferrer = player[_playerAddress].referrer;
            uint i;

            for(i=0; i < 5; i++) {

                if (_nextReferrer != address(0x0)) {
                    //referral commission to level 1
                    if(i == 0) {
                            player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(10).div(100));
                            emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(10).div(100), 1);
                        }
                    else if(i == 1 ) {
                        if(player[_nextReferrer].referralCount >= 2) {
                            player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(2).div(100));
                            emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(2).div(100), 1);
                        }
                    }
                    //referral commission from level 3-5
                    else {
                        if(player[_nextReferrer].referralCount >= i+1) {
                           player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(1).div(100));
                           emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(1).div(100), 1);
                        }
                    }
                }
                else {
                    break;
                }
                _nextReferrer = player[_nextReferrer].referrer;
            }
        }


        //function to manage the referral commission from the daily ROI
        function roiReferralBonus(address _playerAddress, uint256 amount)
        private
        {
            address _nextReferrer = player[_playerAddress].referrer;
            uint i;

            for(i=0; i < 20; i++) {

                if (_nextReferrer != address(0x0)) {
                    if(i == 0) {
                       player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(30).div(100));
                       emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(30).div(100), 2);
                    }
                    //for user 2-5
                    else if(i > 0 && i < 5) {
                        if(player[_nextReferrer].referralCount >= i+1) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(10).div(100));
                            emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(10).div(100), 2);
                        }
                    }
                    //for users 6-10
                    else if(i > 4 && i < 10) {
                        if(player[_nextReferrer].referralCount >= i+1) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(8).div(100));
                            emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(8).div(100), 2);
                        }
                    }
                    //for user 11-15
                    else if(i > 9 && i < 15) {
                        if(player[_nextReferrer].referralCount >= i+1) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(5).div(100));
                            emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(5).div(100), 2);
                        }
                    }
                    else { // for users 16-20
                        if(player[_nextReferrer].referralCount >= i+1) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(1).div(100));
                            emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(1).div(100), 2);
                        }
                    }
                }
                else {
                        break;
                    }
                _nextReferrer = player[_nextReferrer].referrer;
            }
        }



        //function to allow users to withdraw their earnings
        function withdrawEarnings()
        requireUser
        public {
            (uint256 to_payout) = this.payoutOf(getSender());

            require(player[getSender()].incomeLimitLeft > 0, "Limit not available");

            // Deposit payout
            if(to_payout > 0) {
                if(to_payout > player[getSender()].incomeLimitLeft) {
                    to_payout = player[getSender()].incomeLimitLeft;
                }

                player[getSender()].dailyIncome += to_payout;
                player[getSender()].incomeLimitLeft -= to_payout;

                roiReferralBonus(getSender(), to_payout);
            }

            // Direct sponsor bonus
            if(player[getSender()].incomeLimitLeft > 0 && player[getSender()].directsIncome > 0) {
                uint256 direct_bonus = player[getSender()].directsIncome;

                if(direct_bonus > player[getSender()].incomeLimitLeft) {
                    direct_bonus = player[getSender()].incomeLimitLeft;
                }

                player[getSender()].directsIncome -= direct_bonus;
                player[getSender()].incomeLimitLeft -= direct_bonus;
                to_payout += direct_bonus;
            }

            // // Pool payout
            if(player[getSender()].incomeLimitLeft > 0 && player[getSender()].sponsorPoolIncome > 0) {
                uint256 pool_bonus = player[getSender()].sponsorPoolIncome;

                if(pool_bonus > player[getSender()].incomeLimitLeft) {
                    pool_bonus = player[getSender()].incomeLimitLeft;
                }

                player[getSender()].sponsorPoolIncome -= pool_bonus;
                player[getSender()].incomeLimitLeft -= pool_bonus;
                to_payout += pool_bonus;
            }

            // Match payout
            if(player[getSender()].incomeLimitLeft > 0  && player[getSender()].roiReferralIncome > 0) {
                uint256 match_bonus = player[getSender()].roiReferralIncome;

                if(match_bonus > player[getSender()].incomeLimitLeft) {
                    match_bonus = player[getSender()].incomeLimitLeft;
                }

                player[getSender()].roiReferralIncome -= match_bonus;
                player[getSender()].incomeLimitLeft -= match_bonus;
                to_payout += match_bonus;
            }

            //Whale pool Payout
            if(player[getSender()].incomeLimitLeft > 0  && player[getSender()].whalepoolAward > 0) {
                uint256 whale_bonus = player[getSender()].whalepoolAward;

                if(whale_bonus > player[getSender()].incomeLimitLeft) {
                    whale_bonus = player[getSender()].incomeLimitLeft;
                }

                player[getSender()].whalepoolAward -= whale_bonus;
                player[getSender()].incomeLimitLeft -= whale_bonus;
                to_payout += whale_bonus;
            }

            //Premium Adz Referral incomeLimitLeft
            if(player[getSender()].incomeLimitLeft > 0  && player[getSender()].premiumReferralIncome > 0) {
                uint256 premium_bonus = player[getSender()].premiumReferralIncome;

                if(premium_bonus > player[getSender()].incomeLimitLeft) {
                    premium_bonus = player[getSender()].incomeLimitLeft;
                }

                player[getSender()].premiumReferralIncome -= premium_bonus;
                player[getSender()].incomeLimitLeft -= premium_bonus;
                to_payout += premium_bonus;
            }

            require(to_payout > 0, "Zero payout");

            playerTotEarnings[getSender()] += to_payout;
            total_withdraw += to_payout;

            address payable senderAddr = address(uint160(getSender()));
            senderAddr.transfer(to_payout);

             emit withdrawEvent(getSender(), to_payout, now);

        }

        function payoutOf(address _addr) view external returns(uint256 payout) {
            uint256  earningsLimitLeft = player[_addr].incomeLimitLeft;

            if(player[_addr].incomeLimitLeft > 0 ) {
                payout = (player[_addr].currInvestment * ((block.timestamp - player[_addr].depositTime) / 1 days) / 100) - player[_addr].dailyIncome;

                if(player[_addr].dailyIncome + payout > earningsLimitLeft) {
                    payout = earningsLimitLeft;
                }
            }
        }


        //To start the new round for daily pool
        function startNextRound()
        private
         {

            uint256 _roundID = roundID;

            uint256 _poolAmount = round[roundID].pool;

                if (_poolAmount >= 10 ether) {
                    round[_roundID].ended = true;
                    uint256 distributedSponsorAwards = awardTopPromoters();
                    

                    if(etherwhales.length > 0)
                        awardEtherwhales();
                        
                    uint256 _whalePoolAmount = round[roundID].whalepool;

                    _roundID++;
                    roundID++;
                    round[_roundID].startTime = now;
                    round[_roundID].endTime = now.add(poolTime);
                    round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards);
                    round[_roundID].whalepool = _whalePoolAmount;
                }
                else {
                    round[_roundID].startTime = now;
                    round[_roundID].endTime = now.add(poolTime);
                    round[_roundID].pool = _poolAmount;
                }
        }


        function addSponsorToPool(address _add)
            private
            returns (bool)
        {
            if (_add == address(0x0)){
                return false;
            }

            uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
            // if the amount is less than the last on the leaderboard pool, reject
            if (topSponsors[3].amt >= _amt){
                return false;
            }

            address firstAddr = topSponsors[0].addr;
            uint256 firstAmt = topSponsors[0].amt;

            address secondAddr = topSponsors[1].addr;
            uint256 secondAmt = topSponsors[1].amt;

            address thirdAddr = topSponsors[2].addr;
            uint256 thirdAmt = topSponsors[2].amt;



            // if the user should be at the top
            if (_amt > topSponsors[0].amt){

                if (topSponsors[0].addr == _add){
                    topSponsors[0].amt = _amt;
                    return true;
                }
                //if user is at the second position already and will come on first
                else if (topSponsors[1].addr == _add){

                    topSponsors[0].addr = _add;
                    topSponsors[0].amt = _amt;
                    topSponsors[1].addr = firstAddr;
                    topSponsors[1].amt = firstAmt;
                    return true;
                }
                //if user is at the third position and will come on first
                else if (topSponsors[2].addr == _add) {
                    topSponsors[0].addr = _add;
                    topSponsors[0].amt = _amt;
                    topSponsors[1].addr = firstAddr;
                    topSponsors[1].amt = firstAmt;
                    topSponsors[2].addr = secondAddr;
                    topSponsors[2].amt = secondAmt;
                    return true;
                }
                else{

                    topSponsors[0].addr = _add;
                    topSponsors[0].amt = _amt;
                    topSponsors[1].addr = firstAddr;
                    topSponsors[1].amt = firstAmt;
                    topSponsors[2].addr = secondAddr;
                    topSponsors[2].amt = secondAmt;
                    topSponsors[3].addr = thirdAddr;
                    topSponsors[3].amt = thirdAmt;
                    return true;
                }
            }
            // if the user should be at the second position
            else if (_amt > topSponsors[1].amt){

                if (topSponsors[1].addr == _add){
                    topSponsors[1].amt = _amt;
                    return true;
                }
                //if user is at the third position, move it to second
                else if(topSponsors[2].addr == _add) {
                    topSponsors[1].addr = _add;
                    topSponsors[1].amt = _amt;
                    topSponsors[2].addr = secondAddr;
                    topSponsors[2].amt = secondAmt;
                    return true;
                }
                else{
                    topSponsors[1].addr = _add;
                    topSponsors[1].amt = _amt;
                    topSponsors[2].addr = secondAddr;
                    topSponsors[2].amt = secondAmt;
                    topSponsors[3].addr = thirdAddr;
                    topSponsors[3].amt = thirdAmt;
                    return true;
                }
            }
            //if the user should be at third position
            else if(_amt > topSponsors[2].amt){
                if(topSponsors[2].addr == _add) {
                    topSponsors[2].amt = _amt;
                    return true;
                }
                else {
                    topSponsors[2].addr = _add;
                    topSponsors[2].amt = _amt;
                    topSponsors[3].addr = thirdAddr;
                    topSponsors[3].amt = thirdAmt;
                }
            }
            // if the user should be at the fourth position
            else if (_amt > topSponsors[3].amt){

                 if (topSponsors[3].addr == _add){
                    topSponsors[3].amt = _amt;
                    return true;
                }

                else{
                    topSponsors[3].addr = _add;
                    topSponsors[3].amt = _amt;
                    return true;
                }
            }
        }

        function awardTopPromoters()
            private
            returns (uint256)
            {
                uint256 totAmt = round[roundID].pool.mul(10).div(100);
                uint256 distributedAmount;
                uint256 i;


                for (i = 0; i< 4; i++) {
                    if (topSponsors[i].addr != address(0x0)) {
                        player[topSponsors[i].addr].sponsorPoolIncome = player[topSponsors[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));
                        distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
                        emit roundAwardsEvent(topSponsors[i].addr, totAmt.mul(awardPercentage[i]).div(100));

                        lastTopSponsors[i].addr = topSponsors[i].addr;
                        lastTopSponsors[i].amt = topSponsors[i].amt;
                        lastTopSponsorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
                        topSponsors[i].addr = address(0x0);
                        topSponsors[i].amt = 0;
                    }
                    else {
                        break;
                    }
                }

                return distributedAmount;
            }

        function awardEtherwhales()
        private
        {
            uint256 totalWhales = etherwhales.length;

            uint256 toPayout = round[roundID].whalepool.div(totalWhales);
            for(uint256 i = 0; i < totalWhales; i++) {
                player[etherwhales[i]].whalepoolAward = player[etherwhales[i]].whalepoolAward.add(toPayout);
                emit etherWhaleAwardEvent(etherwhales[i], toPayout, now);
            }
            round[roundID].whalepool = 0;
        }

        function premiumInvestment()
        public
        payable {

            uint256 amount = msg.value;

            premiumReferralIncomeDistribution(getSender(), amount);

            address payable ownerAddr = address(uint160(owner));
            ownerAddr.transfer(amount.mul(5).div(100));
            emit premiumInvestmentEvent(getSender(), amount, player[getSender()].currInvestment);
        }

        function premiumReferralIncomeDistribution(address _playerAddress, uint256 amount)
        private {
            address _nextReferrer = player[_playerAddress].referrer;
            uint i;

            for(i=0; i < 5; i++) {

                if (_nextReferrer != address(0x0)) {
                    //referral commission to level 1
                    if(i == 0) {
                        player[_nextReferrer].premiumReferralIncome = player[_nextReferrer].premiumReferralIncome.add(amount.mul(20).div(100));
                        emit premiumReferralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(20).div(100), now);
                    }

                    else if(i == 1 ) {
                        if(player[_nextReferrer].referralCount >= 2) {
                            player[_nextReferrer].premiumReferralIncome = player[_nextReferrer].premiumReferralIncome.add(amount.mul(10).div(100));
                            emit premiumReferralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(10).div(100), now);
                        }
                    }

                    //referral commission from level 3-5
                    else {
                        if(player[_nextReferrer].referralCount >= i+1) {
                            player[_nextReferrer].premiumReferralIncome = player[_nextReferrer].premiumReferralIncome.add(amount.mul(5).div(100));
                            emit premiumReferralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(5).div(100), now);
                        }
                    }
                }
                else {
                    break;
                }
                _nextReferrer = player[_nextReferrer].referrer;
            }
        }


        function drawPool() external onlyOwner {
            startNextRound();
        }
}

library SafeMath {
        /**
         * @dev Returns the addition of two unsigned integers, reverting on
         * overflow.
         *
         * Counterpart to Solidity's `+` operator.
         *
         * Requirements:
         * - Addition cannot overflow.
         */
        function add(uint256 a, uint256 b) internal pure returns (uint256) {
            uint256 c = a + b;
            require(c >= a, "SafeMath: addition overflow");

            return c;
        }

        /**
         * @dev Returns the subtraction of two unsigned integers, reverting on
         * overflow (when the result is negative).
         *
         * Counterpart to Solidity's `-` operator.
         *
         * Requirements:
         * - Subtraction cannot overflow.
         */
        function sub(uint256 a, uint256 b) internal pure returns (uint256) {
            return sub(a, b, "SafeMath: subtraction overflow");
        }

        /**
         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
         * overflow (when the result is negative).
         *
         * Counterpart to Solidity's `-` operator.
         *
         * Requirements:
         * - Subtraction cannot overflow.
         *
         * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
         * @dev Get it via `npm install @openzeppelin/contracts@next`.
         */
        function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
            require(b <= a, errorMessage);
            uint256 c = a - b;

            return c;
        }

        /**
         * @dev Returns the multiplication of two unsigned integers, reverting on
         * overflow.
         *
         * Counterpart to Solidity's `*` operator.
         *
         * Requirements:
         * - Multiplication cannot overflow.
         */
        function mul(uint256 a, uint256 b) internal pure returns (uint256) {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) {
                return 0;
            }

            uint256 c = a * b;
            require(c / a == b, "SafeMath: multiplication overflow");

            return c;
        }

        /**
         * @dev Returns the integer division of two unsigned integers. Reverts on
         * division by zero. The result is rounded towards zero.
         *
         * Counterpart to Solidity's `/` operator. Note: this function uses a
         * `revert` opcode (which leaves remaining gas untouched) while Solidity
         * uses an invalid opcode to revert (consuming all remaining gas).
         *
         * Requirements:
         * - The divisor cannot be zero.
         */
        function div(uint256 a, uint256 b) internal pure returns (uint256) {
            return div(a, b, "SafeMath: division by zero");
        }

        /**
         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
         * division by zero. The result is rounded towards zero.
         *
         * Counterpart to Solidity's `/` operator. Note: this function uses a
         * `revert` opcode (which leaves remaining gas untouched) while Solidity
         * uses an invalid opcode to revert (consuming all remaining gas).
         *
         * Requirements:
         * - The divisor cannot be zero.
         * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
         * @dev Get it via `npm install @openzeppelin/contracts@next`.
         */
        function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
            // Solidity only automatically asserts when dividing by 0
            require(b > 0, errorMessage);
            uint256 c = a / b;
            // assert(a == b * c + a % b); // There is no case in which this doesn't hold

            return c;
        }
    }

library DataStructs {

            struct DailyRound {
                uint256 startTime;
                uint256 endTime;
                bool ended; //has daily round ended
                uint256 pool; //amount in the pool
                uint256 whalepool; //deposits for whalepool
            }

            struct User {
                uint256 id;
                uint256 totalInvestment;
                uint256 directsIncome;
                uint256 roiReferralIncome;
                uint256 currInvestment;
                uint256 dailyIncome;
                uint256 depositTime;
                uint256 incomeLimitLeft;
                uint256 sponsorPoolIncome;
                uint256 referralCount;
                address referrer;
                uint256 cycle;
                uint256 whalepoolAward;
                uint256 premiumReferralIncome;
            }

            struct PlayerDailyRounds {
                uint256 ethVolume;
            }
    }