package myproject.execution;

public interface CommandExecutor {

    String runAndCapture(final String cmd) throws ExecutionException;
}
