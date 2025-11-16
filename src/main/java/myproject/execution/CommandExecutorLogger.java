package myproject.execution;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Objects;

public final class CommandExecutorLogger implements CommandExecutor {

    private static final Logger LOGGER = LogManager.getLogger(CommandExecutorLogger.class);

    private final CommandExecutor delegate;

    public CommandExecutorLogger(final CommandExecutor delegate) {
        this.delegate = Objects.requireNonNull(delegate);
    }

    @Override
    public String runAndCapture(String cmd) throws ExecutionException {
        LOGGER.info("Executing command:\n{}", cmd);
        try {
            final String executionResult = delegate.runAndCapture(cmd);
            LOGGER.info("Execution result:\n{}", executionResult);
            return executionResult;
        } catch (final ExecutionException e) {
            LOGGER.error("Error executing command:\n{} rc = {} out: {}", e.getCmd(), e.getRc(), e.getOut());
            throw e;
        }
    }
}
