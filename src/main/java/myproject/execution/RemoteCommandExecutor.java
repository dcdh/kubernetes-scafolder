package myproject.execution;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Objects;

public final class RemoteCommandExecutor implements CommandExecutor {

    private final String sshUser;
    private final String sshHost;
    private final String sshPass;

    public RemoteCommandExecutor(final String sshUser, final String sshHost, final String sshPass) {
        this.sshUser = Objects.requireNonNull(sshUser);
        this.sshHost = Objects.requireNonNull(sshHost);
        this.sshPass = Objects.requireNonNull(sshPass);
    }

    @Override
    public String runAndCapture(final String cmd) throws ExecutionException {
        try {
            final Process process = new ProcessBuilder(
                    String.join(" ", "sshpass -p", quote(sshPass), "ssh -o StrictHostKeyChecking=no", sshUser + "@" + sshHost, quote(cmd)))
                    .redirectErrorStream(true).start();
            try (final InputStream is = process.getInputStream();
                 final BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                final StringBuilder out = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    out.append(line).append("\n");
                }
                final int rc = process.waitFor();
                if (rc != 0) {
                    throw new ExecutionException(cmd, rc, out.toString(), null);
                }
                return out.toString();
            }
        } catch (final InterruptedException | IOException exception) {
            throw new ExecutionException(null, null, null, exception);
        }
    }

    private static String quote(final String s) {
        return "'" + s.replace("'", "'\\''") + "'";
    }
}
