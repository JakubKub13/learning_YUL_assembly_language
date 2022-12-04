object "Token" {
    code {
        // Store creator of the contract in slot zero
        sstore(0, caller())

        // Deploy the contract
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }
    object "runtime" {
        code {
            // Protection against sending ether
            require(iszero(callvalue()))

            // Dispatcher
            switch selector()
        }
    }
}