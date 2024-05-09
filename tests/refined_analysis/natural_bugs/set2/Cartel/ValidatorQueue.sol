// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {SafeCast} from "openzeppelin-contracts/contracts/utils/math/SafeCast.sol";
import {DataTypes} from "./DataTypes.sol";
import {Errors} from "./Errors.sol";

/**
 * @title ValidatorQueue
 * @notice Library for managing a FIFO queue of validators in the Pirex protocol.
 * @dev This library provides functions for adding, swapping, and removing validators in the validator queue.
 * It also includes functions for popping validators from the end of the queue, retrieving validator information, and clearing the entire queue.
 * @author redactedcartel.finance
 */
library ValidatorQueue {
    /**
     * @notice Emitted when a validator is added to the queue.
     * @dev This event is emitted when a validator is successfully added to the end of the queue.
     * @param pubKey               bytes Public key of the added validator.
     * @param withdrawalCredential bytes Withdrawal credentials associated with the added validator.
     */
    event ValidatorAdded(bytes pubKey, bytes withdrawalCredential);

    /**
     * @notice Emitted when the entire validator queue is cleared.
     * @dev This event is emitted when all validators are removed from the queue, clearing it completely.
     */
    event ValidatorQueueCleared();

    /**
     * @notice Emitted when a validator is removed from the queue.
     * @dev This event is emitted when a validator is successfully removed from the queue, either ordered or unordered.
     * @param pubKey      bytes   Public key of the removed validator.
     * @param removeIndex uint256 Index of the removed validator.
     * @param unordered   bool    Indicates whether the removal was unordered.
     */
    event ValidatorRemoved(bytes pubKey, uint256 removeIndex, bool unordered);

    /**
     * @notice Emitted when validators are popped from the front of the queue.
     * @dev This event is emitted when validators are successfully popped from the front of the queue.
     * @param times uint256 Number of pop operations performed.
     */
    event ValidatorsPopped(uint256 times);

    /**
     * @notice Emitted when two validators are swapped in the queue.
     * @dev This event is emitted when two validators are successfully swapped in the queue.
     * @param fromPubKey bytes   Public key of the first validator being swapped.
     * @param toPubKey   bytes   Public key of the second validator being swapped.
     * @param fromIndex  uint256 Index of the first validator.
     * @param toIndex    uint256 Index of the second validator.
     */
    event ValidatorsSwapped(
        bytes fromPubKey,
        bytes toPubKey,
        uint256 fromIndex,
        uint256 toIndex
    );

    /**
     * @notice Adds a synchronized validator to the FIFO queue, ready for staking.
     * @dev This function adds a validator to the end of the queue with the associated withdrawal credentials.
     * @param deque                 DataTypes.ValidatorDeque Storage reference to the validator deque.
     * @param validator             DataTypes.Validator      Validator information to be added.
     * @param withdrawalCredentials bytes                    Withdrawal credentials associated with the validator.
     */
    function add(
        DataTypes.ValidatorDeque storage deque,
        DataTypes.Validator memory validator,
        bytes memory withdrawalCredentials
    ) external {
        int128 backIndex = deque._end;
        deque._validators[backIndex] = validator;

        unchecked {
            deque._end = backIndex + 1;
        }

        emit ValidatorAdded(validator.pubKey, withdrawalCredentials);
    }

    /**
     * @notice Swaps the location of one validator with another.
     * @dev This function swaps the position of two validators in the queue.
     * @param deque     DataTypes.ValidatorDeque Storage reference to the validator deque.
     * @param fromIndex uint256                  Index of the validator to be swapped.
     * @param toIndex   uint256                  Index of the validator to swap with.
     */
    function swap(
        DataTypes.ValidatorDeque storage deque,
        uint256 fromIndex,
        uint256 toIndex
    ) public {
        if (fromIndex == toIndex) revert Errors.InvalidIndexRanges();
        if (empty(deque)) revert Errors.ValidatorQueueEmpty();

        int128 fromidx = SafeCast.toInt128(
            int256(deque._begin) + SafeCast.toInt256(fromIndex)
        );

        if (fromidx >= deque._end) revert Errors.OutOfBounds();

        int128 toidx = SafeCast.toInt128(
            int256(deque._begin) + SafeCast.toInt256(toIndex)
        );

        if (toidx >= deque._end) revert Errors.OutOfBounds();

        // Get the original values
        DataTypes.Validator memory fromVal = deque._validators[fromidx];
        DataTypes.Validator memory toVal = deque._validators[toidx];

        // Set the swapped values
        deque._validators[toidx] = fromVal;
        deque._validators[fromidx] = toVal;

        emit ValidatorsSwapped(
            fromVal.pubKey,
            toVal.pubKey,
            fromIndex,
            toIndex
        );
    }

    /**
     * @notice Removes validators from the end of the queue, in case they were added in error.
     * @dev This function removes validators from the end of the queue, specified by the number of times to pop.
     * @param  deque     DataTypes.ValidatorDeque Storage reference to the validator deque.
     * @param  times     uint256                  Number of pop operations to perform.
     * @return validator DataTypes.Validator      Removed and returned validator.
     */
    function pop(
        DataTypes.ValidatorDeque storage deque,
        uint256 times
    ) public returns (DataTypes.Validator memory validator) {
        // Loop through and remove validator entries at the end
        for (uint256 _i; _i < times; ) {
            if (empty(deque)) revert Errors.ValidatorQueueEmpty();

            int128 backIndex;

            unchecked {
                backIndex = deque._end - 1;
                ++_i;
            }

            validator = deque._validators[backIndex];
            delete deque._validators[backIndex];
            deque._end = backIndex;
        }

        emit ValidatorsPopped(times);
    }

    /**
     * @notice Check if the deque is empty
     * @dev Returns true if the validator deque is empty, otherwise false.
     * @param deque DataTypes.ValidatorDeque Storage reference to the validator deque.
     * @return      bool                     True if the deque is empty, otherwise false.
     */
    function empty(
        DataTypes.ValidatorDeque storage deque
    ) public view returns (bool) {
        return deque._end <= deque._begin;
    }

    /**
     * @notice Remove a validator from the array using a more gas-efficient loop.
     * @dev Removes a validator at the specified index and emits an event.
     * @param  deque         DataTypes.ValidatorDeque Storage reference to the validator deque.
     * @param  removeIndex   uint256                  Index of the validator to remove.
     * @return removedPubKey bytes                    Public key of the removed validator.
     */
    function removeOrdered(
        DataTypes.ValidatorDeque storage deque,
        uint256 removeIndex
    ) external returns (bytes memory removedPubKey) {
        int128 idx = SafeCast.toInt128(
            int256(deque._begin) + SafeCast.toInt256(removeIndex)
        );

        if (idx >= deque._end) revert Errors.OutOfBounds();

        // Get the pubkey for the validator to remove (for informational purposes)
        removedPubKey = deque._validators[idx].pubKey;

        for (int128 _i = idx; _i < deque._end - 1; ) {
            deque._validators[_i] = deque._validators[_i + 1];

            unchecked {
                ++_i;
            }
        }

        pop(deque, 1);

        emit ValidatorRemoved(removedPubKey, removeIndex, false);
    }

    /**
     * @notice Remove a validator from the array using swap and pop.
     * @dev Removes a validator at the specified index by swapping it with the last validator and then popping the last validator.
     * @param  deque         DataTypes.ValidatorDeque Storage reference to the validator deque.
     * @param  removeIndex   uint256                  Index of the validator to remove.
     * @return removedPubkey bytes                    Public key of the removed validator.
     */
    function removeUnordered(
        DataTypes.ValidatorDeque storage deque,
        uint256 removeIndex
    ) external returns (bytes memory removedPubkey) {
        int128 idx = SafeCast.toInt128(
            int256(deque._begin) + SafeCast.toInt256(removeIndex)
        );

        if (idx >= deque._end) revert Errors.OutOfBounds();

        // Get the pubkey for the validator to remove (for informational purposes)
        removedPubkey = deque._validators[idx].pubKey;

        // Swap the (validator to remove) with the last validator in the array if needed
        uint256 lastIndex = count(deque) - 1;
        if (removeIndex != lastIndex) {
            swap(deque, removeIndex, lastIndex);
        }

        // Pop off the validator to remove, which is now at the end of the array
        pop(deque, 1);

        emit ValidatorRemoved(removedPubkey, removeIndex, true);
    }

    /**
     * @notice Remove the last validator from the validators array and return its information
     * @dev Removes and returns information about the last validator in the queue.
     * @param  deque                   DataTypes.ValidatorDeque  Deque
     * @param  _withdrawalCredentials  bytes                     Credentials
     * @return pubKey                  bytes                     Key
     * @return withdrawalCredentials   bytes                     Credentials
     * @return signature               bytes                     Signature
     * @return depositDataRoot         bytes32                   Deposit data root
     * @return receiver                address                   account to receive pxEth
     */
    function getNext(
        DataTypes.ValidatorDeque storage deque,
        bytes memory _withdrawalCredentials
    )
        external
        returns (
            bytes memory pubKey,
            bytes memory withdrawalCredentials,
            bytes memory signature,
            bytes32 depositDataRoot,
            address receiver
        )
    {
        if (empty(deque)) revert Errors.ValidatorQueueEmpty();

        int128 frontIndex = deque._begin;
        DataTypes.Validator memory popped = deque._validators[frontIndex];
        delete deque._validators[frontIndex];

        unchecked {
            deque._begin = frontIndex + 1;
        }

        // Return the validator's information
        pubKey = popped.pubKey;
        withdrawalCredentials = _withdrawalCredentials;
        signature = popped.signature;
        depositDataRoot = popped.depositDataRoot;
        receiver = popped.receiver;
    }

    /**
     * @notice Return the information of the i'th validator in the registry
     * @dev Returns information about the validator at the specified index without removing it from the deque.
     * @param  deque                   DataTypes.ValidatorDeque  Deque
     * @param  _withdrawalCredentials  bytes                     Credentials
     * @param  _index                  uint256                   Index
     * @return pubKey                  bytes                     Key
     * @return withdrawalCredentials   bytes                     Credentials
     * @return signature               bytes                     Signature
     * @return depositDataRoot         bytes32                   Deposit data root
     * @return receiver                address                   account to receive pxEth
     */
    function get(
        DataTypes.ValidatorDeque storage deque,
        bytes memory _withdrawalCredentials,
        uint256 _index
    )
        external
        view
        returns (
            bytes memory pubKey,
            bytes memory withdrawalCredentials,
            bytes memory signature,
            bytes32 depositDataRoot,
            address receiver
        )
    {
        // int256(deque._begin) is a safe upcast
        int128 idx = SafeCast.toInt128(
            int256(deque._begin) + SafeCast.toInt256(_index)
        );

        if (idx >= deque._end) revert Errors.OutOfBounds();

        DataTypes.Validator memory _v = deque._validators[idx];

        // Return the validator's information
        pubKey = _v.pubKey;
        withdrawalCredentials = _withdrawalCredentials;
        signature = _v.signature;
        depositDataRoot = _v.depositDataRoot;
        receiver = _v.receiver;
    }

    /**
     * @notice Empties the validator queue.
     * @dev Clears the entire validator deque, setting both begin and end to 0.
     *      Emits an event to signal the clearing of the queue.
     * @param deque DataTypes.ValidatorDeque Storage reference to the validator deque.
     */
    function clear(DataTypes.ValidatorDeque storage deque) external {
        deque._begin = 0;
        deque._end = 0;

        emit ValidatorQueueCleared();
    }

    /**
     * @notice Returns the number of validators in the queue.
     * @dev Calculates and returns the number of validators in the deque.
     * @param deque DataTypes.ValidatorDeque Storage reference to the validator deque.
     * @return      uint256                  Number of validators in the deque.
     */
    function count(
        DataTypes.ValidatorDeque storage deque
    ) public view returns (uint256) {
        // The interface preserves the invariant that begin <= end so we assume this will not overflow.
        // We also assume there are at most int256.max items in the queue.
        unchecked {
            return uint256(int256(deque._end) - int256(deque._begin));
        }
    }
}
