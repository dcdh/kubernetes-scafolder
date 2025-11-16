package myproject;

import myproject.execution.CommandExecutor;
import myproject.execution.CommandExecutorLogger;
import myproject.execution.RemoteCommandExecutor;
import picocli.CommandLine;

import java.util.List;


public class App implements Runnable {

    @CommandLine.Option(
            names = {"-u", "--user"},
            description = "Utilisateur SSH (défaut: ${DEFAULT-VALUE})"
    )
    private String sshUser = "damien";

    @CommandLine.Option(
            names = {"-H", "--host"},
            description = "Hôte SSH (défaut: ${DEFAULT-VALUE})"
    )
    private String sshHost = "192.168.59.113";

    @CommandLine.Option(
            names = {"-p", "--pass"},
            description = "Mot de passe SSH (défaut: ${DEFAULT-VALUE})",
            interactive = true
    )
    private String sshPass = "damien";

    @Override
    public void run() {
        final CommandExecutor commandExecutor = new CommandExecutorLogger(
                new RemoteCommandExecutor(sshUser, sshHost, sshPass));
        final List<String> commands = List.of(
//                "echo '%s' | sudo -S swapoff -a".formatted(sshPass),
//                "echo '%s' | sudo -S sed -e '/swap/ s/^#*/#/' -i /etc/fstab".formatted(sshPass),
//                "echo '%s' | sudo -S systemctl mask swap.target".formatted(sshPass),
                "echo \"net.ipv4.ip_forward=1\" | echo '%s' | sudo -S tee /usr/lib/sysctl.d/100-k8s.conf".formatted(sshPass));
        commands.forEach(commandExecutor::runAndCapture);
    }

    public static void main(String[] args) {
        int exitCode = new CommandLine(new App()).execute(args);
        System.exit(exitCode);
    }
}
