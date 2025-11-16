package myproject.execution;

public class ExecutionException extends RuntimeException {

    private final String cmd;
    private final Integer rc;
    private final String out;

    public ExecutionException(final String cmd, final Integer rc, final String out, final Throwable cause) {
        super(cause);
        this.cmd = cmd;
        this.rc = rc;
        this.out = out;
    }

    public String getCmd() {
        return cmd;
    }

    public Integer getRc() {
        return rc;
    }

    public String getOut() {
        return out;
    }
}
