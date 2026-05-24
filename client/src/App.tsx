import Box from '@mui/material/Box';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';

export function App() {
  return (
    <Box
      component="main"
      sx={{
        minHeight: '100vh',
        display: 'grid',
        placeItems: 'center',
        px: 3,
        py: 6,
        textAlign: 'center',
      }}
    >
      <Stack spacing={2} sx={{ maxWidth: 560 }}>
        <Typography component="h1" variant="h3">
          מרדף המילים פועל
        </Typography>
        <Typography color="text.secondary" variant="h6">
          תשתית עברית ומימין לשמאל מוכנה להמשך העבודה.
        </Typography>
      </Stack>
    </Box>
  );
}
